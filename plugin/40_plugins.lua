local add = vim.pack.add
local now, now_if_args, later, on_filetype =
  Config.now, Config.now_if_args, Config.later, Config.on_filetype

-- Colorscheme & Transparency
now(function()
  add({
    'https://github.com/rebelot/kanagawa.nvim',
    'https://github.com/xiyaowong/transparent.nvim',
  })

  local Kanagawa = require('kanagawa')
  Kanagawa.setup({
    overrides = function(colors)
      return {
        MiniPickTargetLine = { bg = colors.palette.carpYellow, bold = true },
      }
    end,
  })

  Kanagawa.load('wave')

  require('transparent').setup({
    extra_groups = { 'NormalFloat', 'MiniPickBorder', 'FloatBorder' }, --
    exclude_groups = {
      'MiniPickTargetLine',
      'MiniPickMatchCurrent',
    },
  })

  local colors = require('kanagawa.colors').setup({ theme = 'wave' })
  vim.api.nvim_set_hl(0, 'MiniPickTargetLine', {
    bg = colors.palette.carpYellow,
    fg = colors.palette.sumiInk0, -- Adding a dark foreground for contrast
    bold = true,
    force = true, -- Use force to override any plugin links
  })
end)

-- Tree-sitter ================================================================
now_if_args(function()
  local ts_update = function() vim.cmd('TSUpdate') end
  Config.on_packchanged('nvim-treesitter', { 'update' }, ts_update, ':TSUpdate')
  add({
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
  })

  -- Ensure installed
  --stylua: ignore
  local ensure_languages = {
    'bash', 'c',          'cpp',  'css',   'diff', 'go', 'nix'
    'html', 'javascript', 'json', 'julia', 'nu',   'php', 'python',
    'r',    'regex',      'rst',  'rust',  'toml', 'tsx', 'typescript', 'yaml',
  }
  local isnt_installed = function(lang)
    return #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false) == 0
  end
  local to_install = vim.tbl_filter(isnt_installed, ensure_languages)
  if #to_install > 0 then require('nvim-treesitter').install(to_install) end

  -- Ensure enabled
  local filetypes = vim
    .iter(ensure_languages)
    :map(vim.treesitter.language.get_filetypes)
    :flatten()
    :totable()
  vim.list_extend(filetypes, { 'markdown', 'quarto' })
  local ts_start = function(ev) vim.treesitter.start(ev.buf) end
  Config.new_autocmd('FileType', filetypes, ts_start, 'Ensure enabled tree-sitter')

  -- Miscellaneous adjustments
  vim.treesitter.language.register('markdown', 'quarto')
  vim.filetype.add({
    extension = { qmd = 'quarto', Qmd = 'quarto' },
  })
end)

-- Install LSP/formatting/linter executables ==================================
now_if_args(function()
  -- Enable LSP only on Neovim>=0.11 as it introduced `vim.lsp.config`
  if vim.fn.has('nvim-0.11') == 0 then return end

  add({
    'https://github.com/mason-org/mason.nvim',
    'https://github.com/williamboman/mason-lspconfig.nvim',
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/hrsh7th/nvim-cmp',
    'https://github.com/hrsh7th/cmp-nvim-lsp',
  })

  require('mason').setup()
  require('mason-lspconfig').setup()

  local cmp = require('cmp')
  cmp.setup({
    mapping = cmp.mapping.preset.insert({
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<C-Space>'] = cmp.mapping.complete(),
    }),
    sources = { { name = 'nvim_lsp' } },
  })

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local has_cmp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
  if has_cmp and type(cmp_lsp.default_capabilities) == 'function' then
    capabilities =
      vim.tbl_deep_extend('force', capabilities, cmp_lsp.default_capabilities())
  end
  vim.lsp.config('*', { capabilities = capabilities })

  vim.lsp.enable({
    'clangd',
    'gopls',
    'lua_ls',
    'bashls',
    'ty',
    'r_language_server',
    'rust_analyzer',
    'vtsls',
    'solidity_ls_nomicfoundation',
  })
end)

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
      javascript = { 'vtsls' },
      typescript = { 'vtsls' },
      json = { 'prettier' },
      lua = { 'stylua' },
      python = { 'ruff_fix', 'ruff_format' },
      r = { 'air' },
      nix = { 'nixfmt' },
      solidity = { 'solidity_ls_nomicfoundation' },
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

-- Custom Auto Commands =======================================================

-- for mini.pick
vim.api.nvim_set_hl(
  0,
  'MiniPickMatchCurrent',
  { fg = '#E56B1A', bold = true, bg = 'NONE' }
)

-- not always updating the LSP when inserting
vim.diagnostic.config({
  update_in_insert = false,
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    local opts = { buffer = event.buf }

    -- The classic 'Go to Definition'
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)

    -- You might also want these if they're missing:
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set(
      'n',
      '<leader>cr',
      vim.lsp.buf.rename,
      { buffer = event.buf, desc = 'LSP: [C]ode [R]ename' }
    )
  end,
})
