local configPath = function()
	if vim.fn.has("unix") == 1 then
		return "~/.config/nvim/"
	else
		return "%APPDATA%/nvim/"
	end
end

return {
	{
		"nvim-lualine/lualine.nvim",
		opts = {
			sections = {
				lualine_x = {
					require("cmake_build_type").lualine_component(),
					{ "encoding", show_bomb = true },
					"fileformat",
				},
			},
		},
	},
	{
		"lervag/vimtex",
		init = function()
			vim.g.vimtex_view_method = "zathura"
		end,
	},
	{
		"glepnir/template.nvim",
		event = "VeryLazy",
		cmd = { "Template", "TemProject" },
		config = function()
			require("template").setup({
				temp_dir = configPath() .. "/template/",
				author = "黄建超",
				email = "hjc@xszn-tech.com",
			})
		end,
	},
	{
		"iamcco/markdown-preview.nvim",
		init = function()
			vim.g.mkdp_theme = "light"
			vim.g.mkdp_debug = 1
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				cmake = { "cmake_format" },
			},
			formatters = {
				prettier = {
					prepend_args = function()
						return { "--use-tabs", "--tab-width", "4" }
					end,
				},
				cmake_format = {
					prepend_args = function()
						return { "--line-width", "120", "--use-tabchars", "--tab-size", "4", "--max-subgroups-hwrap", "99", "--max-pargs-hwrap", "99" }
					end,
				},
			},
		},
	},
}
