--------------------------------------------------------------------------------
-- rc/lsp.lua – Neovim 0.10+ 専用（inlay-hint 新 API 使用）
--------------------------------------------------------------------------------
local capabilities = require("rc.capabilities").get()
local on_attach = function(_) end  -- ここにキー設定などを足す

-- =============================================================================
-- 2. LSP 設定 – 新 API (vim.lsp.config + vim.lsp.enable)
-- =============================================================================

-- 2.0 すべてのクライアントに共通オプションを適用
vim.lsp.config('*', {
  capabilities = capabilities,
  on_attach = on_attach,
})

-- 2.1 C/C++
if vim.fn.executable('ccls') == 1 then
  vim.lsp.config('ccls', {
    cmd = { 'ccls' },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
    root_markers = {
      '.ccls',
      'compile_commands.json',
      'compile_flags.txt',
      '.git',
    },
    workspace_required = true,
  })
  vim.lsp.enable('ccls')
end

-- 2.2 TypeScript / JavaScript
vim.lsp.config('ts_ls', {
  filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' },
  root_markers = {
    'package.json',
    'tsconfig.json',
    'jsconfig.json',
    '.git',
  },
})
vim.lsp.enable('ts_ls')
