return {
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      sections = {
        lualine_x = { { "encoding", show_bomb = true }, "fileformat" },
      },
    },
  },
  {
    "lervag/vimtex",
    opts = function()
      vim.g.vimtex_view_method = "zathura"
      return {}
    end,
  },
}
