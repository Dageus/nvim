local add = vim.pack.add
local now_if_args = Config.now_if_args
local servers = Config.lsp_servers
local tools = Config.tools

-- Install LSP/formatting/linter executables ==================================
now_if_args(function()
  -- Enable LSP only on Neovim>=0.11 as it introduced `vim.lsp.config`
  if vim.fn.has('nvim-0.11') == 0 then return end

  add({
    'https://github.com/mason-org/mason.nvim',
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/mason-org/mason-lspconfig.nvim',
    'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',

    -- trying nvim-cmp again
    'https://github.com/hrsh7th/nvim-cmp',
    'https://github.com/hrsh7th/cmp-nvim-lsp',
  })

  require('mason').setup()
  require('mason-lspconfig').setup({
    -- List the LSP servers you want automatically installed
    ensure_installed = servers,
    -- Automatically set up servers you've configured via vim.lsp.config
    automatic_installation = true,
  })
  require('mason-tool-installer').setup({
    ensure_installed = tools,
  })

  local cmp = require('cmp')
  cmp.setup({
    -- avoid selecting the first item automatically
    preselect = cmp.PreselectMode.None,
    -- no auto-inserting
    completion = {
      completeopt = 'menu,menuone,noinsert',
    },
    mapping = cmp.mapping.preset.insert({
      -- accept suggestion
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      -- complete
      ['<C-Space>'] = cmp.mapping.complete(),
      -- Select the [n]ext item
      ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
      -- Select the [p]revious item
      ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),

      -- Scroll the documentation window [b]ack / [f]orward
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
    }),
    snippet = {
      expand = function(args) vim.snippet.expand(args.body) end,
    },
    sources = { { name = 'nvim_lsp' } },
    performance = {
      max_view_entries = 8,
    },
    window = {
      -- The actual suggestion menu
      completion = cmp.config.window.bordered({
        border = 'single', -- Sharp corners
        winhighlight = 'Normal:Pmenu,FloatBorder:PmenuBorder,CursorLine:PmenuSel,Search:None',
      }),
      -- The extra documentation window (appears to the side)
      documentation = cmp.config.window.bordered({
        border = 'single',
        winhighlight = 'Normal:Pmenu,FloatBorder:PmenuBorder,CursorLine:PmenuSel,Search:None',
      }),
    },
  })

  -- disable nvim autocompletion
  vim.o.autocomplete = false

  -- LSP Configuration
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local has_cmp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
  if has_cmp and type(cmp_lsp.default_capabilities) == 'function' then
    capabilities =
      vim.tbl_deep_extend('force', capabilities, cmp_lsp.default_capabilities())
  end
  vim.lsp.config('*', { capabilities = capabilities })

  for _, server in ipairs(servers) do
    vim.lsp.enable(server)
  end
end)
