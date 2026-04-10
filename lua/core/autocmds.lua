vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- not always updating the LSP when inserting
vim.diagnostic.config({
  update_in_insert = false,
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    local opts = { buffer = event.buf }

    local client = vim.lsp.get_client_by_id(event.data.client_id)

    -- Specifically target the Solidity LSP to fix highlighting
    if client and client.name == 'solidity_ls_nomicfoundation' then
      client.server_capabilities.semanticTokensProvider = nil
    end

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
