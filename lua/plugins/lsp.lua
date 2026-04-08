local add = vim.pack.add
local now_if_args = Config.now_if_args
local servers = Config.lsp_servers

-- Install LSP/formatting/linter executables ==================================
now_if_args(function()
  -- Enable LSP only on Neovim>=0.11 as it introduced `vim.lsp.config`
  if vim.fn.has('nvim-0.11') == 0 then return end

  add({
    'https://github.com/mason-org/mason.nvim',
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/mason-org/mason-lspconfig.nvim',
  })

  require('mason').setup()
  require("mason-lspconfig").setup({
    -- List the LSP servers you want automatically installed
    ensure_installed = servers,
    -- Automatically set up servers you've configured via vim.lsp.config
    automatic_installation = true,
  })

  -- Native NeoVim autocompletion
  vim.o.autocomplete = true
  vim.o.complete = 'o,.^5,t^3,w' -- omnifunc (LSP), Buffer, tags, windows
  vim.o.pummaxwidth = 40
  vim.o.pumheight = 6
  vim.o.completeopt = 'menu,menuone,noselect,fuzzy'

  -- LSP Configuration
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  vim.lsp.config('*', { capabilities = capabilities })

  for _, server in ipairs(servers) do
    vim.lsp.enable(server)
  end
end)
