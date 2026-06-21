return {
	"yetone/avante.nvim",
	opts = {
		system_prompt = "你是一个专业的中文AI编程助手。所有回答、代码注释、解释说明都必须使用简体中文。代码中的变量名和函数名可以使用英文，但注释和对话必须用中文。",
		-- 自动补全配置
		behaviour = {
			auto_suggestions = false,
			auto_suggestions_respect_ignore = false,
			enable_token_counting = true, -- 🆕 开启 token 计数，监控上下文用量
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
				extra_request_body = {
					thinking = { type = "disabled" },
					stream = true,
					max_completion_tokens = 8192,
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
					max_completion_tokens = 32768, -- 🔧 128→32768，充分利用输出能力,
				},
			},
		},
	},
}
