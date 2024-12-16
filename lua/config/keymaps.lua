-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.del({ "v", "n" }, "s")
-- vim.keymap.del("n","<leader>S")

vim.keymap.set("n", "<leader>mbc", "<CMD>CMakeBuildCurrentFile<CR>", { desc = "cmake build cur file" })
vim.keymap.set("n", "<leader>mbb", "<CMD>CMakeBuild<CR>", { desc = "cmake build file" })
