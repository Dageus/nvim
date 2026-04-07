local add = vim.pack.add
local now_if_args = Config.now_if_args

-- Tree-sitter ================================================================
now_if_args(function()
  local ts_update = function() vim.cmd('TSUpdate') end
  Config.on_packchanged('nvim-treesitter', { 'update' }, ts_update, ':TSUpdate')
  add({
    'https://github.com/nvim-treesitter/nvim-treesitter',
  })

  -- Ensure installed
  --stylua: ignore
  local ensure_languages = {
    'bash', 'c',          'cpp',  'css',   'diff', 'go', 'nix',
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
