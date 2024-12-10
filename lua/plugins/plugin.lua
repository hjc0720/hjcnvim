local configPath = function()
  if vim.fn.has("unix") == 1 then
    return "~/.config/nvim/"
  else
    return "%APPDATA%/nvim/"
  end
end

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
  {
    "glepnir/template.nvim",
    event = "VeryLazy",
    cmd = { "Template", "TemProject" },
    config = function()
      require("template").setup({
        temp_dir = configPath() .. "/template/",
        author = "黄建超",
        email = "hjc@xszn-tech.com",
      })
    end,
  },
}
