local add = vim.pack.add
local later, on_filetype = Config.later, Config.on_filetype

-- Formatting =================================================================
later(function()
  add({ 'https://github.com/stevearc/conform.nvim' })

  require('conform').setup({
    default_format_opts = {
      -- Allow formatting from LSP server if no dedicated formatter is available
      lsp_format = 'fallback',
    },
    -- Map of filetype to formatters
    formatters_by_ft = {
      javascript = { 'prettier' },
      typescript = { 'prettier' },
      json = { 'prettier' },
      lua = { 'stylua' },
      python = { 'ruff_fix', 'ruff_format' },
      r = { 'air' },
      nix = { 'nixfmt' },
      solidity = { 'prettier' },
    },
  })
end)

-- Filetype: markdown =========================================================
on_filetype('markdown', function()
  local build = function()
    vim.cmd.packadd('markdown-preview.nvim')
    vim.fn['mkdp#util#install']()
  end
  Config.on_packchanged(
    'markdown-preview.nvim',
    { 'install', 'update' },
    build,
    'Build markdown-preview'
  )
  add({ 'https://github.com/iamcco/markdown-preview.nvim' })

  -- Do not close the preview tab when switching to other buffers
  vim.g.mkdp_auto_close = 0
end)

-- Add a keymap to trigger formatting
vim.keymap.set(
  'n',
  '<leader>lf',
  '<Cmd>lua require("conform").format()<CR>',
  { desc = 'Format file' }
)
