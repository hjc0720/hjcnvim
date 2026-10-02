# AGENTS.md

## What this is

Personal [LazyVim](https://github.com/LazyVim/LazyVim) Neovim configuration.
The repo is symlinked to `~/.config/nvim` via `setup.sh` — it is the live config, not a build artifact.

## Directory layout

```
init.lua                  → bootstrap; calls require("config.lazy")
lua/config/lazy.lua       → lazy.nvim setup; imports LazyVim base + lua/plugins/
lua/config/options.lua    → vim.opt overrides, conform-on-save autocmd, custom filetypes
lua/config/autocmds.lua   → autoformat toggle per filetype, GBK encoding detection
lua/config/keymaps.lua    → extra keymaps (CMake build shortcuts)
lua/plugins/*.lua         → one file per concern; all returned specs merged by lazy.nvim
lua/cmake_build_type.lua  → standalone module: lualine component for cmake-tools build type
lazyvim.json              → which LazyVim extras are enabled (lang packs, dap, mini-surround)
lazy-lock.json            → pinned plugin commits (like a lockfile)
template/                 → template.nvim templates (e.g. main.cpp with author/date placeholders)
```

## Conventions agents should know

### Formatting

- **Lua**: StyLua with tabs, width 120 (`stylua.toml`). The config auto-formats Lua on save via conform.
- **C/C++**: clang-format (Google base, tabs, width 120, Mozilla braces). Autoformat is **disabled** for cpp (`autocmds.lua` line 18) — formatting only runs on explicit request.
- **Other filetypes**: prettier is configured with `--use-tabs --tab-width 4`.

### Editor defaults (non-standard)

- Tabs everywhere (`expandtab = false`), shiftwidth/tabstop = 4.
- Relative line numbers are **off** (`relativenumber = false`).
- Shell is set to PowerShell (`vim.opt.shell = "powershell"`) — this is a Windows-primary setup.
- Clipboard is `unnamedplus` (system clipboard).
- Custom filetype associations: `.glsl`, `.hlsl`, `.vs`, `.fs`, `.gs`, `.PS`, `.VS` → glsl/hlsl.

### Plugin architecture

- Every `.lua` file in `lua/plugins/` is auto-loaded by lazy.nvim. Drop a new file there to add plugins.
- `example.lua` is the upstream LazyVim starter example — it short-circuits with `if true then return {} end` and is never loaded. Safe to delete or ignore.
- `disabled.lua` returns `{}` — placeholder for disabling plugins. Also safe to ignore.
- `color.lua` sets the colorscheme to **gruvbox**.
- `avante.nvim` is explicitly **disabled** (`enabled = false`).
- `minuet-ai.nvim` provides AI code completion via DeepSeek, auto-triggered only for `c`/`cpp` files.

### LazyVim extras enabled (`lazyvim.json`)

Language packs: clangd, cmake, git, go, json, markdown, python, tex, vue.
Also: mini-surround, DAP core.

### CMake integration

- `cmake-tools.nvim` is configured with parallel build (`-j<ncpu>`).
- Custom keymaps: `<leader>mbc` builds current file, `<leader>mbb` builds project.
- `lua/cmake_build_type.lua` provides a lualine component showing build type (Debug=red, Release=green) — only visible in CMake projects.

### Template system

- `template.nvim` uses `template/` dir for file templates. Author is hardcoded in `plugin.lua`.

## What not to do

- Don't change shell settings without understanding the Windows/PowerShell dependency in `options.lua`.
- Don't enable `expandtab` globally — tabs are the intentional default.
- Don't re-enable `avante.nvim` without checking with the owner — it was deliberately disabled.
- Don't edit `lazy-lock.json` manually — it's managed by lazy.nvim's update mechanism.
- Don't remove the GBK encoding detection in `autocmds.lua` — it handles legacy Chinese-encoded files.
