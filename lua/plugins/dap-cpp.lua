-- DAP 配置：Windows C++ 调试 (codelldb)
local is_win = vim.fn.has("win32") == 1

if not is_win then
	return {}
end

local mason_path = vim.fn.stdpath("data") .. "/mason/packages"
local codelldb_path = mason_path .. "/codelldb/extension/adapter/codelldb.exe"

return {
	{
		"mfussenegger/nvim-dap",
		opts = function()
			local dap = require("dap")
			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = codelldb_path,
					args = { "--port", "${port}" },
				},
			}
			-- C++ 调试配置模板
			dap.configurations.cpp = {
				{
					name = "Launch (codelldb)",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input(
							"Executable path: ",
							vim.fn.getcwd() .. "/bin/win64_debug/",
							"file"
						)
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					args = {},
				},
				{
					name = "Launch with args (codelldb)",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input(
							"Executable path: ",
							vim.fn.getcwd() .. "/bin/win64_debug/",
							"file"
						)
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					args = function()
						local args_str = vim.fn.input("Arguments: ")
						return vim.split(args_str, " ")
					end,
				},
				{
					name = "Attach to process (codelldb)",
					type = "codelldb",
					request = "attach",
					pid = require("dap.utils").pick_process,
					cwd = "${workspaceFolder}",
				},
			}
			-- C 也使用同样的配置
			dap.configurations.c = dap.configurations.cpp
		end,
	},
}