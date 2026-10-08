-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.del({ "v", "n" }, "s")

local is_win = vim.fn.has("win32") == 1

-- 找构建脚本：优先 vim.g.build_script，否则在当前目录找常见入口
local function find_build_script()
	if vim.g.build_script and vim.g.build_script ~= "" then
		return vim.g.build_script
	end
	local candidates = is_win and { "build_win.bat", "build.bat" } or { "build_linux.sh", "build.sh" }
	for _, name in ipairs(candidates) do
		if vim.fn.filereadable(name) == 1 then
			return name
		end
	end
	return vim.fn.input("Build script: ", candidates[1], "file")
end

-- 判断是否合法 UTF-8（build_win.bat 有 chcp 65001，正常输出就是 UTF-8）
local function is_valid_utf8(s)
	local i, n = 1, #s
	while i <= n do
		local b = s:byte(i)
		if b < 0x80 then
			i = i + 1
		elseif b >= 0xC2 and b <= 0xDF then
			if i + 1 > n then
				return false
			end
			local c = s:byte(i + 1)
			if c < 0x80 or c > 0xBF then
				return false
			end
			i = i + 2
		elseif b >= 0xE0 and b <= 0xEF then
			if i + 2 > n then
				return false
			end
			local c1, c2 = s:byte(i + 1), s:byte(i + 2)
			if c1 < 0x80 or c1 > 0xBF or c2 < 0x80 or c2 > 0xBF then
				return false
			end
			i = i + 3
		elseif b >= 0xF0 and b <= 0xF4 then
			if i + 3 > n then
				return false
			end
			for j = 1, 3 do
				local c = s:byte(i + j)
				if c < 0x80 or c > 0xBF then
					return false
				end
			end
			i = i + 4
		else
			return false
		end
	end
	return true
end

-- 输出行转 UTF-8：已是 UTF-8 就不动，否则按 cp936 转
local function to_utf8(line)
	if is_valid_utf8(line) then
		return line
	end
	return vim.fn.iconv(line, "cp936", "utf-8") or line
end

-- 运行构建脚本（异步），输出解析进 quickfix，有错误自动跳到第一条
local function build_with_quickfix(script, args)
	local cmd
	if is_win then
		cmd = { "cmd.exe", "/c", script }
	else
		cmd = { script }
	end
	for _, a in ipairs(args or {}) do
		table.insert(cmd, a)
	end

	local title = table.concat(cmd, " ")
	-- 按下按键后立即弹出 quickfix，构建期间可看到输出
	vim.fn.setqflist({}, " ", { lines = { "[BUILD] running: " .. title .. " ..." }, title = title })
	vim.cmd("botright copen")
	vim.api.nvim_echo({ { "[BUILD] " .. title, "WarningMsg" } }, true, {})

	local raw_lines = {}
	local finalized = false

	-- 实时追加输出到 quickfix；始终写入 raw_lines（on_exit 可能早于最后一次 stdout）
	local function append_lines(data)
		local items = {}
		for _, line in ipairs(data) do
			if line ~= "" then
				local l = to_utf8(line:gsub("\r$", ""))
				raw_lines[#raw_lines + 1] = l
				items[#items + 1] = { text = l }
			end
		end
		if #items == 0 or finalized then
			return
		end
		vim.schedule(function()
			if finalized then
				return
			end
			vim.fn.setqflist(items, "a")
			-- quickfix 窗口滚到最新一行
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				if vim.api.nvim_win_is_valid(win) and vim.bo[vim.api.nvim_win_get_buf(win)].buftype == "quickfix" then
					local buf = vim.api.nvim_win_get_buf(win)
					local last = vim.api.nvim_buf_line_count(buf)
					pcall(vim.api.nvim_win_set_cursor, win, { last, 0 })
				end
			end
			vim.cmd("redraw")
		end)
	end

	local efm = table.concat({
		-- MSVC: file.cpp(10): error C2065: msg
		[[%f(%l): %t%*[^:]: %m]],
		-- MSVC 带列号: file.cpp(10,5): error C2065: msg（逗号须转义，否则被当成分隔符）
		[[%f(%l\,%c): %t%*[^:]: %m]],
		-- 链接器/工具: foo.obj : error LNK2019: msg（mt.exe : command line error ... 也命中）
		[[%f : %t%*[^:]: %m]],
		-- gcc/clang: file.cpp:10:5: error: msg
		[[%f:%l:%c:\ %t%*[^:]:\ %m]],
		-- gcc/clang: file.cpp:10: error: msg
		[[%f:%l:\ %t%*[^:]:\ %m]],
		-- CMake: CMake Error at CMakeLists.txt:10
		[[CMake Error at %f:%l]],
		-- 兜底：mt.exe : command line error ... 等工具错误
		[[%*[^:] : %m]],
	}, ",")

	-- 从日志里补充 efm 认不出的条目（如 ninja 的 FAILED: 目标）
	local function upgrade_qf_items(raw)
		local all = vim.fn.getqflist()
		for i, line in ipairs(raw) do
			local failed = line:match("^FAILED:%s+(%S+)")
			if failed and all[i] then
				all[i] = { filename = failed, lnum = 1, text = "build failed target: " .. failed }
			end
		end
		vim.fn.setqflist(all, " ")
	end

	local function finalize(code)
		if finalized then
			return
		end
		finalized = true

		-- 用 errorformat 解析；解析不到也保留完整日志，避免输出“消失”
		vim.fn.setqflist({}, " ", { lines = raw_lines, efm = efm, title = title })
		upgrade_qf_items(raw_lines)

		local first_valid
		for i, item in ipairs(vim.fn.getqflist()) do
			if item.valid == 1 then
				first_valid = i
				break
			end
		end

		if first_valid then
			vim.cmd("cc " .. first_valid)
			local total = 0
			for _, item in ipairs(vim.fn.getqflist()) do
				if item.valid == 1 then
					total = total + 1
				end
			end
			vim.notify(string.format("[BUILD] done, exit=%d, %d error(s), ]q/:cnext to navigate", code, total), vim.log.levels.WARN)
			return
		end

		-- 没有可跳转的错误：保留日志，只在末尾追加状态行
		local note = code == 0 and "[BUILD] succeeded" or ("[BUILD] failed, exit=" .. code .. " (no parseable errors)")
		local all = vim.fn.getqflist()
		all[#all + 1] = { text = note }
		vim.fn.setqflist(all, " ")
		if code == 0 then
			vim.api.nvim_echo({ { note, "MoreMsg" } }, true, {})
			vim.notify(note, vim.log.levels.INFO)
		else
			vim.notify(note, vim.log.levels.ERROR)
		end
	end

	-- shellslash 会破坏进程命令行拼装（cmd.exe 报「命令语法不正确」），启动期间先关掉
	local saved_slash = vim.o.shellslash
	vim.o.shellslash = false
	local job = vim.fn.jobstart(cmd, {
		on_stdout = function(_, data)
			append_lines(data)
		end,
		on_stderr = function(_, data)
			append_lines(data)
		end,
		on_exit = function(_, code)
			-- on_exit 可能早于最后一次 stdout，延迟收尾把剩余输出收进来
			vim.defer_fn(function()
				vim.schedule(function()
					finalize(code)
				end)
			end, 80)
		end,
	})
	vim.o.shellslash = saved_slash
	if job <= 0 then
		vim.notify("[BUILD] failed to start: " .. title, vim.log.levels.ERROR)
	end
end

if is_win then
	-- Windows: mbc 走 MSBuild，mbb/mbr 走构建脚本（如 vgSource 的 build_win.bat）
	vim.keymap.set("n", "<leader>mbc", function()
		local file = vim.fn.expand("%:p")
		vim.cmd("!msbuild " .. vim.fn.shellescape(file) .. " /t:ClCompile /p:Configuration=Debug /m")
	end, { desc = "MSBuild compile current file" })

	vim.keymap.set("n", "<leader>mbb", function()
		local script = find_build_script()
		if script ~= "" then
			build_with_quickfix(script, { "Debug" })
		end
	end, { desc = "build script Debug → quickfix" })

	vim.keymap.set("n", "<leader>mbr", function()
		local script = find_build_script()
		if script ~= "" then
			build_with_quickfix(script, { "Release" })
		end
	end, { desc = "build script Release → quickfix" })
else
	-- Linux: CMake 快捷键
	vim.keymap.set("n", "<leader>mbc", "<CMD>CMakeBuildCurrentFile<CR>", { desc = "cmake build cur file" })
	vim.keymap.set("n", "<leader>mbb", "<CMD>CMakeBuild<CR>", { desc = "cmake build" })
end
