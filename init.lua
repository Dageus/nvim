-- Leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install 'mini.nvim'
vim.pack.add({ 'https://github.com/nvim-mini/mini.nvim' })

-- Define main config table to be able to pass data between scripts
_G.Config = {}

-- Loading helpers
local misc = require('mini.misc')
Config.now = function(f) misc.safely('now', f) end
Config.later = function(f) misc.safely('later', f) end
Config.now_if_args = vim.fn.argc(-1) > 0 and Config.now or Config.later
Config.on_event = function(ev, f) misc.safely('event:' .. ev, f) end
Config.on_filetype = function(ft, f) misc.safely('filetype:' .. ft, f) end

-- Define custom autocommand group
local gr = vim.api.nvim_create_augroup('custom-config', {})
Config.new_autocmd = function(event, pattern, callback, desc)
  local opts = { group = gr, pattern = pattern, callback = callback, desc = desc }
  vim.api.nvim_create_autocmd(event, opts)
end

-- Define custom `vim.pack.add()` hook helper
Config.on_packchanged = function(plugin_name, kinds, callback, desc)
  if vim.fn.has('nvim-0.12') == 0 then return end
  local f = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then return end
    if not ev.data.active then vim.cmd.packadd(plugin_name) end
    callback()
  end
  Config.new_autocmd('PackChanged', '*', f, desc)
end

-- Define LSP's
Config.lsp_servers = {
  'clangd',
  'gopls',
  'lua_ls',
  'bashls',
  'basedpyright',
  'rust_analyzer',
  'vtsls',
  'solidity_ls_nomicfoundation',
}

-- Define Tools
Config.tools = {
  'stylua',
  'ruff',
  'prettier',
  'nixfmt',
}

Config.languages = {
  'bash',
  'c',
  'cpp',
  'css',
  'diff',
  'go',
  'nix',
  'html',
  'javascript',
  'json',
  'julia',
  'nu',
  'php',
  'python',
  'r',
  'regex',
  'rst',
  'rust',
  'toml',
  'tsx',
  'typescript',
  'yaml',
}

-- Loading settings
require('core.options')
require('core.keymaps')
require('core.autocmds')
require('core.functions')

-- Loading plugins
require('plugins.mini')
require('plugins.colorscheme')
require('plugins.tree_sitter')
require('plugins.lsp')
require('plugins.formatting')
require('plugins.extra')

-- Custom Highlights =======================================================

vim.api.nvim_set_hl(
  0,
  'MiniStatuslineModeNormal',
  { fg = '#16161D', bg = '#938aa9', bold = true }
)

-- Sharp orange border for completion
vim.api.nvim_set_hl(0, 'PmenuBorder', { fg = '#938aa9', bg = 'NONE' })
-- The "selection" bar inside the menu (the line you are currently on)
vim.api.nvim_set_hl(0, 'PmenuSel', { bg = '#2D2D2D', fg = 'NONE' })

vim.api.nvim_set_hl(0, 'PmenuExtra', { bg = 'NONE' })
vim.api.nvim_set_hl(0, 'PmenuKind', { bg = 'NONE', italic = true })

-- for mini.pick
vim.api.nvim_set_hl(
  0,
  'MiniPickMatchCurrent',
  { fg = '#938aa9', bold = true, bg = 'NONE' }
)

vim.api.nvim_set_hl(0, 'MiniFilesCursorLine', {
  fg = '#938aa9',
  bold = true,
  bg = 'NONE',
  force = true,
})

-- Inject the highlight into mini.files windows when they open
vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniFilesWindowOpen',
  desc = 'Highlight current line in mini.files for transparent backgrounds',
  callback = function(args)
    local win_id = args.data.win_id
    -- Swap the default CursorLine to our custom orange foreground highlight
    vim.wo[win_id].winhighlight = 'CursorLine:MiniFilesCursorLine'
  end,
})
