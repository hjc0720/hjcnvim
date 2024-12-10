local ncpu = #vim.loop.cpu_info()

return {
  {
    "Civitasv/cmake-tools.nvim",
    opts = {
      cmake_build_options = { "-j" .. tostring(ncpu) },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "cpp" } },
  },
  {
    "nvim-cmp",
    opts = function(_, opts)
      table.insert(opts.sorting.comparators, 1, require("clangd_extensions.cmp_scores"))
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Ensure mason installs the server
        clangd = {
          keys = {
            { "<leader>o", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
          },
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern(
              "Makefile",
              "configure.ac",
              "configure.in",
              "config.h.in",
              "meson.build",
              "meson_options.txt",
              "build.ninja"
            )(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(
              fname
            ) or require("lspconfig.util").find_git_ancestor(fname)
          end,
          capabilities = {
            offsetEncoding = { "utf-16" },
          },
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
        },
      },
      setup = {
        clangd = function(_, opts)
          local clangd_ext_opts = LazyVim.opts("clangd_extensions.nvim")
          require("clangd_extensions").setup(vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = opts }))
          return false
        end,
        on_new_config = function(new_config, new_cmd)
          local status, cmake = pcall(require, "cmake-tools")
          if status then
            cmake.clangd_on_new_config(new_config)
          end
        end,
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    keys = {
      -- add a keymap to browshttps://github.com/cmu-db/bustub.gite plhttps://github.com/cmu-db/bustub.gitugin files
      -- stylua: ignore
      {
        "<F5>",
        function() require("dap").continue() end,
        desc = "launch/continue gdb",
      },
      {
        "<F10>",
        function()
          require("dap").step_over()
        end,
        desc = "单步调试",
      },
      {
        "<F11>",
        function()
          require("dap").step_into()
        end,
        desc = "步入",
      },
      {
        "<S-F11>",
        function()
          require("dap").step_out()
        end,
        desc = "步出",
      },
      {
        "<C-f5>",
        function()
          require("dap").terminate()
        end,
        desc = "终止程序",
      },
    },
  },
}
