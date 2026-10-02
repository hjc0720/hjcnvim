-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.del({ "v", "n" }, "s")

local is_win = vim.fn.has("win32") == 1

if is_win then
	-- Windows: MSBuild 快捷键
	vim.keymap.set("n", "<leader>mbc", function()
		local file = vim.fn.expand("%:p")
		vim.cmd("!msbuild " .. vim.fn.shellescape(file) .. " /t:ClCompile /p:Configuration=Debug /m")
	end, { desc = "MSBuild compile current file" })

	vim.keymap.set("n", "<leader>mbb", function()
		local sln = vim.fn.input("Solution: ", "source\\xszn_main.sln", "file")
		if sln ~= "" then
			vim.cmd("!msbuild " .. vim.fn.shellescape(sln) .. " /p:Configuration=Debug /m")
		end
	end, { desc = "MSBuild build solution (Debug)" })

	vim.keymap.set("n", "<leader>mbr", function()
		local sln = vim.fn.input("Solution: ", "source\\xszn_main.sln", "file")
		if sln ~= "" then
			vim.cmd("!msbuild " .. vim.fn.shellescape(sln) .. " /p:Configuration=Release /m")
		end
	end, { desc = "MSBuild build solution (Release)" })
else
	-- Linux: CMake 快捷键
	vim.keymap.set("n", "<leader>mbc", "<CMD>CMakeBuildCurrentFile<CR>", { desc = "cmake build cur file" })
	vim.keymap.set("n", "<leader>mbb", "<CMD>CMakeBuild<CR>", { desc = "cmake build" })
end