local ncpu = #vim.loop.cpu_info()
local is_win = vim.fn.has("win32") == 1

return {
	-- clangd 配置
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				clangd = {
					capabilities = {
						offsetEncoding = { "utf-16" },
					},
					cmd = (function()
						local args = {
							"--background-index",
							"--clang-tidy",
							"--header-insertion=iwyu",
							"--completion-style=detailed",
							"--function-arg-placeholders",
							"--fallback-style=llvm",
						}
						if is_win then
							table.insert(args, "--pch-storage=memory")
						end
						table.insert(args, 1, "clangd")
						return args
					end)(),
					init_options = {
						usePlaceholders = true,
						completeUnimported = true,
						clangdFileStatus = true,
					},
				},
			},
		},
	},
	-- cmake-tools (仅 Linux 使用)
	{
		"Civitasv/cmake-tools.nvim",
		enabled = not is_win,
		opts = {
			cmake_build_options = { "-j" .. tostring(ncpu) },
		},
	},
	-- clangd_extensions
	{
		"p00f/clangd_extensions.nvim",
		opts = {
			inlay_hints = {
				inline = false,
			},
			ast = {
				role_icons = {
					type = "T",
					declaration = "D",
					expression = "E",
					statement = "S",
					specifier = "V",
				},
				kind_icons = {
					Compound = "C",
					Recovery = "R",
					TranslationUnit = "T",
					PackExpansion = "P",
					TemplateTypeParm = "T",
					TemplateTemplateParm = "T",
					TemplateParamObject = "T",
				},
			},
		},
	},
}