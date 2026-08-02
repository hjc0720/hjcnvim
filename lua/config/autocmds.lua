-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--
local set_autoformat = function(pattern, bool_val)
  vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = pattern,
    callback = function()
      vim.b.autoformat = bool_val
      vim.opt_local.expandtab = true
      vim.opt_local.tabstop = 4
      vim.opt_local.shiftwidth = 4
      vim.opt_local.softtabstop = 4
    end,
  })
end

set_autoformat({ "cpp" }, false)
set_autoformat({ "lua" }, true)

-- 智能检测 GBK 编码文件并自动以正确编码打开
-- 原理：fileencodings 按顺序尝试，但 GBK 文件的英文部分在 UTF-8 下是合法的，
-- 所以 nvim 会优先匹配到 utf-8 而不会继续尝试 gbk。
-- 这里通过检测文件中是否包含 GBK 中文字节（0x81-0xFE 开头），
-- 且不是合法的 UTF-8 序列，来判断是否需要以 GBK 重新打开。
local function has_gbk_chinese_bytes(bufnr)
  local max_check = 50 -- 最多检查前50行
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, max_check, false)
  for _, line in ipairs(lines) do
    -- GBK 中文字节范围：第一个字节 0x81-0xFE，第二个字节 0x40-0xFE
    for b1, b2 in line:gmatch("([\129-\254])([\64-\254])") do
      local b1_val = string.byte(b1)
      local b2_val = string.byte(b2)
      -- 如果是合法的 UTF-8 双字节序列 (0xC0-0xDF, 0x80-0xBF)，跳过
      if b1_val >= 0xC0 and b1_val <= 0xDF and b2_val >= 0x80 and b2_val <= 0xBF then
        -- 跳过，继续检查
      -- 如果是合法的 UTF-8 三字节序列开头 (0xE0-0xEF, 0x80-0xBF)，跳过
      elseif b1_val >= 0xE0 and b1_val <= 0xEF and b2_val >= 0x80 and b2_val <= 0xBF then
        -- 跳过，继续检查
      else
        -- 不是合法的 UTF-8 序列，说明很可能是 GBK 编码
        return true
      end
    end
  end
  return false
end

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  pattern = "*",
  callback = function(args)
    local bufnr = args.buf
    local fenc = vim.bo[bufnr].fileencoding
    if fenc ~= "" and fenc ~= "utf-8" then
      return
    end
    if vim.bo[bufnr].binary then
      return
    end
    local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr))
    if fsize > 1024 * 1024 then
      return
    end
    if has_gbk_chinese_bytes(bufnr) then
      vim.cmd("silent! edit ++enc=gbk")
    end
  end,
})
