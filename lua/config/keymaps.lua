-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.del({ "v", "n" }, "s")
-- vim.keymap.del("n","<leader>S")

vim.keymap.set("n", "<leader>m", "<cmd><leader>ss<CR>", { desc = "find doc symbols" })
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>O", builtin.git_files, { desc = "find file in git" })
vim.keymap.set("n", "<leader>S", builtin.lsp_dynamic_workspace_symbols, { desc = "find symbols in git" })

local function cmakeBuildAll()
  require("cmake-tools").build({ target = "all" })
end

-- vim.keymap.set("n","<leader>mb",cmakeBuildAll,{desc = "cmake build file"})
vim.keymap.set("n", "<leader>mb", "<CMD>CMakeBuildCurrentFile<CR>", { desc = "cmake build file" })
