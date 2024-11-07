return {
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      sections = {
        lualine_x = { { "encoding", show_bomb = true }, "fileformat" },
      },
    },
  },
}
