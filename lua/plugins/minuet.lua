return {
	-- 1. 添加 minuet-ai.nvim 插件
	{
		"milanglacier/minuet-ai.nvim",
		config = function()
			require("minuet").setup({
				notify = "debug",
				-- 2. 配置 DeepSeek V4 的 Provider (这里没有变动)
				provider = "openai_fim_compatible",
				provider_options = {
					openai_fim_compatible = {
						api_key = "DEEPSEEK_API_KEY",
						name = "deepseek",
						optional = {
							max_tokens = 256,
							top_p = 0.9,
						},
					},
				},

				-- 3. 【更新】完整的 Virtual Text 前端配置
				virtualtext = {
					-- 3.1 控制前端功能的全局开关 (重要!)
					enabled = true, -- 设为 false 可全局禁用虚拟文本前端

					-- 3.2 控制自动触发功能的文件类型 (默认为空表，表示所有文件类型都开启)
					-- 如果你想为特定文件类型禁用自动触发，可以在这里配置
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

				-- 4. 可选：调整请求性能参数 (这里没有变动)
				throttle = 200,
				debounce = 500,

				-- 5. 可选：如果你使用 nvim-cmp，建议调整超时时间 (这里没有变动)
				-- performance = {
				--     fetching_timeout = 2000,
				-- },
			})
		end,
		-- 确保 minuet 在 nvim-cmp 之后加载，以便正确添加源
		dependencies = { "hrsh7th/nvim-cmp" },
	},

	-- 6. 【重要】如果你同时使用 nvim-cmp 和 virtualtext 前端，请删除或禁用此部分！
	-- 注：为防止冲突，我已将 nvim-cmp 的配置部分完全移除。如需单独添加，可取消下方注释。
	-- {
	--     "hrsh7th/nvim-cmp",
	--     optional = true,
	--     opts = function(_, opts)
	--         table.insert(opts.sources, 1, { name = "minuet" })
	--         opts.performance = opts.performance or {}
	--         opts.performance.fetching_timeout = 2000
	--         return opts
	--     end,
	-- },
}
