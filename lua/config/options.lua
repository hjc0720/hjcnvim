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
