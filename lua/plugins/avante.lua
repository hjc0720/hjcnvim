return {
	"yetone/avante.nvim",
	opts = {
		-- 自动补全配置
		behaviour = {
			auto_suggestions = false,
			auto_suggestions_respect_ignore = false,
		},
		-- 自动补全专用 provider（flash 模型，响应快）
		auto_suggestions_provider = "deepseek",
		-- 建议请求频率控制
		suggestion = {
			debounce = 150,
			throttle = 600,
		},
		-- 对话使用 deepseekV4
		provider = "deepseekV4",
		mode = "agentic", -- Switch from "agentic" to "legacy"
		-- DeepSeek 配置
		providers = {
			deepseek = {
				__inherited_from = "openai",
				api_key_name = "DEEPSEEK_API_KEY",
				endpoint = "https://api.deepseek.com/beta",
				model = "deepseek-v4-flash",
				timeout = 30000,
				max_tokens = 128,
				extra_request_body = {
					thinking = { type = "disabled" },
					stream = true,
				},
			},
			deepseekV4 = {
				__inherited_from = "claude",
				api_key_name = "DEEPSEEK_API_KEY",
				endpoint = "https://api.deepseek.com/anthropic",
				model = "deepseek-v4-pro",
				extra_request_body = {
					thinking = { type = "disabled" },
					stream = true,
				},
			},
		},
	},
}
