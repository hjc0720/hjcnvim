-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt
-- opt.autochdir = true

opt.expandtab = false
opt.shiftwidth = 4
opt.tabstop = 4
opt.fileencodings = { "ucs-bom", "utf-8", "cp936", "gbk", "latin1", "utf-16" }
opt.relativenumber = false
opt.termguicolors = true
opt.textwidth = 120
opt.formatoptions:append("t")
opt.formatoptions:remove("l")

vim.o.clipboard = "unnamedplus"

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

vim.filetype.add({
	extension = {
		glsl = "glsl",
		hlsl = "hlsl",
		vs = "glsl", -- 可选：将 .vs 文件关联为 glsl
		fs = "glsl", -- 可选：将 .fs 文件关联为 glsl
		gs = "glsl", -- 可选：将 .gs 文件关联为 glsl
		PS = "glsl",
		VS = "glsl",
		-- ... 其他自定义文件类型关联
	},
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "glsl", "hlsl" }, -- 为 glsl 和 hlsl 文件类型设置
	callback = function()
		vim.bo.shiftwidth = 4 -- 设置缩进为 4 个空格
		vim.bo.tabstop = 4 -- 设置 Tab 宽度为 4 个空格
		vim.bo.expandtab = false -- 将 Tab 转换为空格
		-- 其他缓冲区本地选项...
	end,
})
