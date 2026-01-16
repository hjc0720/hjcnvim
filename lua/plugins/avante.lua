return {
	"yetone/avante.nvim",
	opts = {
		-- 基础配置
		suggestion = {
			enabled = true,
			auto_trigger = true,
			hide_during_completion = false,
		},
		provider = "deepseek",
		-- DeepSeek 配置
		providers = {
			deepseek = {
				__inherited_from = "openai",
				api_key_name = "DEEPSEEK_API_KEY",
				endpoint = "https://api.deepseek.com/v1",
				model = "deepseek-coder",
				timeout = 30000,
			},
		},
	},
}

-- return {
-- 	{
-- 		"yetone/avante.nvim",
-- 		-- 基础配置
-- 		suggestion = {
-- 			enabled = true,
-- 			auto_trigger = true,
-- 			hide_during_completion = false,
-- 		},
-- 		provider = "deepseek",
-- 		providers = {
-- 			deepseek = {
-- 				__inherited_from = "openai",
-- 				endpoint = "https://api.deepseek.com",
-- 				model = "deepseek-coder",
-- 			},
-- 		},
-- 	},
-- }
