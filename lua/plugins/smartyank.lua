return {
	"ibhagwan/smartyank.nvim",
	event = "VeryLazy",
	opts = {
		-- 剪贴板设置 (可选)
		clipboard = {
			enabled = true,
		},
		-- OSC 52 设置 (SSH 剪贴板的关键)
		osc52 = {
			enabled = true, -- 启用 OSC 52
			ssh_only = true, -- 仅在 SSH 会话中启用，避免干扰本地
			silent = false, -- 是否静默操作
		},
	},
}
