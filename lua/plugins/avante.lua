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
		mode = "agentic", -- Switch from "agentic" to "legacy"
		-- DeepSeek 配置
		providers = {
			deepseek = {
				__inherited_from = "openai",
				api_key_name = "DEEPSEEK_API_KEY",
				endpoint = "https://api.deepseek.com",
				model = "deepseek-v4-pro",
				timeout = 30000,
				extra_request_body = {
					thinking = { type = "disabled" },
				},
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
