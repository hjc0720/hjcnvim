return {
	-- 1. 添加 minuet-ai.nvim 插件
	{
		"milanglacier/minuet-ai.nvim",
		config = function()
			require("minuet").setup({
				--			notify = "debug",
				-- 2. 配置 DeepSeek V4 的 Provider
				provider = "openai_fim_compatible",
				provider_options = {
					openai_fim_compatible = {
						api_key = "DEEPSEEK_API_KEY",
						name = "deepseek",
						optional = {
							max_tokens = 512,
							top_p = 0.9,
						},
					},
				},

				-- 3. Virtual Text 前端配置
				virtualtext = {
					-- 3.1 控制前端功能的全局开关
					enabled = true,

					-- 3.2 控制自动触发功能的文件类型 (默认为空表，表示所有文件类型都开启)
					auto_trigger_ft = { "c", "cpp" },

					-- 3.3 快捷键映射
					keymap = {
						accept = "<A-A>", -- 接受整个补全
						accept_line = "<A-a>", -- 仅接受当前补全的第一行
						accept_n_lines = "<A-z>", -- 接受指定行数的补全 (按下后会提示输入数字)
						next = "<A-]>", -- 下一个补全建议
						prev = "<A-[>", -- 上一个补全建议
						dismiss = "<A-e>", -- 取消当前显示的补全建议
					},
				},

				-- 4. 禁用 blink.cmp 自动补全（使用 virtualtext 前端）
				blink = {
					enable_auto_complete = false,
				},

				-- 5. 可选：调整请求性能参数
				debounce = 100, -- 防抖，延迟debounce才发送请求
				throttle = 800, -- 两次请求间隔throttle
			})
		end,
	},

	-- 6. 将 minuet 注册为 blink.cmp 的补全源（保留配置，后续可切换回 blink）
	{
		"saghen/blink.cmp",
		optional = true,
		opts = function(_, opts)
			-- 追加 minuet 到默认补全源列表（不覆盖已有的 lsp/path/snippets/buffer）
			local default_sources = opts.sources.default
			if type(default_sources) == "table" and not vim.tbl_contains(default_sources, "minuet") then
				table.insert(default_sources, "minuet")
			end

			-- 注册 minuet provider
			opts.sources.providers = opts.sources.providers or {}
			opts.sources.providers.minuet = {
				name = "Minuet",
				module = "minuet.blink",
				score_offset = 3,
			}

			return opts
		end,
	},
}
