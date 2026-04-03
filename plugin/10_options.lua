-- General ====================================================================
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

vim.o.timeoutlen = 300

vim.o.clipboard = 'unnamedplus'
vim.o.undofile = true

vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true

-- UI =========================================================================
vim.o.showmode = false

-- Sets how neovim will display certain whitespace characters in the editor.
-- vim.o.list = true
-- vim.o.listchars = 'extends:…,nbsp:␣,precedes:…,tab:│ ,trail:·'
vim.opt.list = true
vim.opt.listchars = { tab = '  ', trail = '·', nbsp = '␣' }

vim.o.wrap = false -- Don't visually wrap lines (toggle with \w)
vim.o.breakindent = true -- Indent wrapped lines to match line start
vim.o.breakindentopt = 'list:-1' -- Add padding for lists (if 'wrap' is set)
vim.o.scrolloff = 11
vim.o.signcolumn = 'yes' -- Always show signcolumn (less flicker)
vim.o.splitbelow = true -- Horizontal splits will be below
vim.o.splitkeep = 'screen' -- Reduce scroll during window split
vim.o.splitright = true -- Vertical splits will be to the right
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.termguicolors = true

-- Folds (default behavior; see `:h Folding`)
vim.o.foldenable = false    -- Disable folding at startup
vim.o.foldlevelstart = 99   -- Ensure all folds are opened if folding is turned on later
-- NOTE: old
-- vim.o.foldlevel = 1 -- Fold everything except top level
-- vim.o.foldmethod = 'indent' -- Fold based on indent level
-- vim.o.foldnestmax = 10 -- Limit number of fold levels

-- Experimental
vim.o.cursorlineopt = 'screenline,number' -- Show cursor line per screen line

if vim.fn.has('nvim-0.10') == 0 then vim.o.termguicolors = true end

if vim.fn.has('nvim-0.12') == 1 then
  vim.o.completetimeout = 100

  vim.o.pumborder = 'bold' -- Use border in built-in completion menu

  require('vim._core.ui2').enable({ enable = true })
end

-- Editing ====================================================================
vim.o.autoindent = true -- Use auto indent
vim.o.expandtab = true -- Convert tabs to spaces
vim.o.formatoptions = 'rqnl1j' -- Improve comment editing
vim.o.ignorecase = true -- Ignore case during search
vim.o.incsearch = true -- Show search matches while typing
vim.o.infercase = true -- Infer case in built-in completion
vim.o.shiftwidth = 2 -- Use this number of spaces for indentation
vim.o.smartcase = true -- Respect case if search pattern has upper case
vim.o.smartindent = true -- Make indenting smart
vim.o.spell = true
vim.o.spelllang = 'en,uk,pt' -- Define spelling dictionaries
vim.o.spelloptions = 'camel' -- Treat camelCase word parts as separate words
vim.o.tabstop = 2 -- Show tab as this number of spaces
vim.o.virtualedit = 'block' -- Allow going past end of line in blockwise mode

vim.o.dictionary = vim.fn.stdpath('config') .. '/misc/dict/english.txt' -- Use specific dictionaries

-- Disabling transparency for mini_pick
vim.api.nvim_set_hl(0, "MiniPickMatchCurrent", { reverse = true })
