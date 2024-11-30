-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt
opt.autochdir = true

opt.expandtab = false
opt.shiftwidth = 4
opt.tabstop = 4
opt.fileencodings = { "ucs-bom", "utf-8", "cp936", "gbk", "latin1", "utf-16" }
opt.relativenumber = false
opt.termguicolors = true

vim.o.clipboard = "unnamedplus"
