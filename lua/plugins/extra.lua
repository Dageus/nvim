local add = vim.pack.add
local later = Config.later

-- Indent scope
later(function()
  add({ 'https://github.com/lukas-reineke/indent-blankline.nvim' })
  require('ibl').setup()
end)

-- Snippet collection =========================================================
later(function() add({ 'https://github.com/rafamadriz/friendly-snippets' }) end)

-- Test runner ================================================================
later(function()
  add({
    'https://github.com/tpope/vim-dispatch',
    'https://github.com/vim-test/vim-test',
  })
  vim.cmd([[let test#strategy = 'neoterm']])
  vim.cmd([[let test#python#runner = 'pytest']])
end)
