-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.del({ "v", "n" }, "s")
-- vim.keymap.del("n","<leader>S")

-- vim.keymap.set("n", "<leader>mm", "<leader>ss", { desc = "find doc symbols" })
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>O", builtin.git_files, { desc = "find file in git" })
vim.keymap.set("n", "<leader>S", builtin.lsp_dynamic_workspace_symbols, { desc = "find symbols in git" })

vim.keymap.set("n", "<leader>mbc", "<CMD>CMakeBuildCurrentFile<CR>", { desc = "cmake build cur file" })
vim.keymap.set("n", "<leader>mbb", "<CMD>CMakeBuild<CR>", { desc = "cmake build file" })
