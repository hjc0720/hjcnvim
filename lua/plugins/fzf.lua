-- 在 LazyVim 配置中添加 (~/.config/nvim/lua/plugins/fzf.lua)
return {
	{
		"ibhagwan/fzf-lua",
		config = function()
			require("fzf-lua").setup({
				-- 禁用有问题的 transform 动作
				actions = {
					files = {
						-- 使用默认动作替代 transform
						["default"] = require("fzf-lua.actions").file_edit,
					},
				},
			})
		end,
	},
}
