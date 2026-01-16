local ncpu = #vim.loop.cpu_info()

return {
	{
		"Civitasv/cmake-tools.nvim",
		opts = {
			cmake_build_options = { "-j" .. tostring(ncpu) },
		},
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				cmd = { "clangd", "--header-insertion=never" },
				filetypes = { "c", "cpp" },
			},
		},
	},
	-- {
	-- 	"neovim/nvim-lspconfig",
	-- 	opts = {
	-- 		servers = {
	-- 			-- Ensure mason installs the server
	-- 			clangd = {
	-- 				keys = {
	-- 					{ "<leader>o", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
	-- 				},
	-- 				root_dir = function(fname)
	-- 					return require("lspconfig.util").root_pattern(
	-- 						"Makefile",
	-- 						"configure.ac",
	-- 						"configure.in",
	-- 						"config.h.in",
	-- 						"meson.build",
	-- 						"meson_options.txt",
	-- 						"build.ninja"
	-- 					)(fname) or require("lspconfig.util").root_pattern(
	-- 						"compile_commands.json",
	-- 						"compile_flags.txt"
	-- 					)(fname) or require("lspconfig.util").find_git_ancestor(fname)
	-- 				end,
	-- 				capabilities = {
	-- 					offsetEncoding = { "utf-16" },
	-- 				},
	-- 				cmd = {
	-- 					"clangd",
	-- 					"--background-index",
	-- 					"--clang-tidy",
	-- 					"--header-insertion=iwyu",
	-- 					"--completion-style=detailed",
	-- 					"--function-arg-placeholders",
	-- 					"--fallback-style=llvm",
	-- 				},
	-- 				init_options = {
	-- 					usePlaceholders = true,
	-- 					completeUnimported = true,
	-- 					clangdFileStatus = true,
	-- 				},
	-- 			},
	-- 		},
	-- 		setup = {
	-- 			clangd = function(_, opts)
	-- 				local clangd_ext_opts = LazyVim.opts("clangd_extensions.nvim")
	-- 				require("clangd_extensions").setup(
	-- 					vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = opts })
	-- 				)
	-- 				return false
	-- 			end,
	-- 			on_new_config = function(new_config, new_cmd)
	-- 				local status, cmake = pcall(require, "cmake-tools")
	-- 				if status then
	-- 					cmake.clangd_on_new_config(new_config)
	-- 				end
	-- 			end,
	-- 		},
	-- 	},
	-- },
}
