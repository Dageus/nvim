local now, later = Config.now, Config.later

now(function()
  require('mini.icons').setup({
    use_file_extension = function(ext, _)
      local suf3, suf4 = ext:sub(-3), ext:sub(-4)
      return suf3 ~= 'scm'
        and suf3 ~= 'txt'
        and suf3 ~= 'yml'
        and suf4 ~= 'json'
        and suf4 ~= 'yaml'
    end,
  })
  later(MiniIcons.mock_nvim_web_devicons)
  later(MiniIcons.tweak_lsp_kind)
end)

now(function()
  local predicate = function(notif)
    if
      not (notif.data.source == 'lsp_progress' and notif.data.client_name == 'lua_ls')
    then
      return true
    end
    -- Filter out some LSP progress notifications from 'lua_ls'
    return notif.msg:find('Diagnosing') == nil
      and notif.msg:find('semantic tokens') == nil
  end
  local custom_sort = function(notif_arr)
    return MiniNotify.default_sort(vim.tbl_filter(predicate, notif_arr))
  end

  require('mini.notify').setup({ content = { sort = custom_sort } })
end)

now(function() require('mini.sessions').setup() end)

now(function() require('mini.starter').setup() end)

local statusline = require('mini.statusline')
statusline.setup({
  content = {
    active = function()
      local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })

      local git = MiniStatusline.section_git({ trunc_width = 40 })

      -- Colors and background
      local function get_bg(hl_group)
        local hl = vim.api.nvim_get_hl(0, { name = hl_group, link = false })
        return hl.bg and string.format('#%06x', hl.bg) or 'NONE'
      end

      local function get_fg(hl_group)
        local hl = vim.api.nvim_get_hl(0, { name = hl_group, link = false })
        return hl.fg and string.format('#%06x', hl.fg) or 'NONE'
      end

      local dev_bg = get_bg('MiniStatuslineDevinfo')

      local err_fg = get_fg('DiagnosticError')
      local warn_fg = get_fg('DiagnosticWarn')

      vim.api.nvim_set_hl(0, 'StDiagError', { fg = err_fg, bg = dev_bg })
      vim.api.nvim_set_hl(0, 'StDiagWarn', { fg = warn_fg, bg = dev_bg })

      -- local function get_diagnostics()
      --   local count = vim.diagnostic.count(0)
      --   local errors = count[vim.diagnostic.severity.ERROR] or 0
      --   local warnings = count[vim.diagnostic.severity.WARN] or 0
      --   local items = {}
      --   if errors > 0 then table.insert(items, '%#StDiagError#X ' .. errors) end
      --   if warnings > 0 then table.insert(items, '%#StDiagWarn#! ' .. warnings) end
      --   return table.concat(items, ' ')
      -- end
      -- local diag_str = get_diagnostics()
      local diag_str = vim.diagnostic.status() or ''

      -- Filename info
      local filename = vim.fn.expand('%:t')
      if filename == '' then filename = '[No Name]' end
      if vim.bo.modified then filename = filename .. ' [+]' end
      if vim.bo.readonly then filename = filename .. ' [RO]' end

      -- Git & Diagnostics
      local progress = vim.ui.progress_status() or ''
      local dev_info = git
      if diag_str ~= '' then
        dev_info = (git ~= '' and (git .. '  ') or '') .. diag_str
      end
      if progress ~= '' then
        dev_info = (dev_info ~= '' and (dev_info .. '  ') or '') .. progress
      end

      local mode_bg = get_bg(mode_hl)
      local file_bg = get_bg('MiniStatuslineFilename')
      local info_bg = get_bg('MiniStatuslineFileinfo')
      local status_bg = get_bg('StatusLine')

      vim.api.nvim_set_hl(0, 'StModeToDev', { fg = mode_bg, bg = dev_bg })
      vim.api.nvim_set_hl(0, 'StModeToFile', { fg = mode_bg, bg = file_bg })
      vim.api.nvim_set_hl(0, 'StDevToFile', { fg = dev_bg, bg = file_bg })
      vim.api.nvim_set_hl(0, 'StFileToMid', { fg = file_bg, bg = status_bg })

      vim.api.nvim_set_hl(0, 'StMidToInfo', { fg = info_bg, bg = status_bg })
      vim.api.nvim_set_hl(0, 'StInfoToMode', { fg = mode_bg, bg = info_bg })

      local left = string.format('%%#%s# %s %%#StModeToDev#', mode_hl, mode:upper())
      if dev_info ~= '' then
        left = left
          .. string.format('%%#MiniStatuslineDevinfo# %s %%#StDevToFile#', dev_info)
      end
      left = left
        .. string.format('%%#MiniStatuslineFilename# %s %%#StFileToMid#', filename)

      local encoding = vim.bo.fenc ~= '' and vim.bo.fenc or vim.o.enc
      local filetype = vim.bo.filetype
      local lsp_status = #vim.lsp.get_clients({ bufnr = 0 }) > 0 and '󰄭 ' or ''

      local right_info =
        string.format('%s  %s  %s', encoding, lsp_status, filetype)
      local location = string.format('%s', '%l:%c')

      local right = string.format(
        '%%#StMidToInfo#%%#MiniStatuslineFileinfo# %s %%#StInfoToMode#%%#%s# %s ',
        right_info,
        mode_hl,
        location
      )

      return left .. '%=' .. right
    end,

    inactive = function()
      local filename = vim.fn.expand('%:t')
      if filename == '' then filename = '[No Name]' end
      return '%#MiniStatuslineInactive# ' .. filename .. '%='
    end,
  },
})

-- Step two ===================================================================
later(function() require('mini.extra').setup() end)

later(function()
  local ai = require('mini.ai')
  ai.setup({
    custom_textobjects = {
      B = MiniExtra.gen_ai_spec.buffer(),
      f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
      c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }),
      o = ai.gen_spec.treesitter({ a = '@block.outer', i = '@block.inner' }),
    },
    search_method = 'cover',
  })
end)

later(function() require('mini.align').setup() end)

later(function() require('mini.bracketed').setup() end)

later(function() require('mini.bufremove').setup() end)

later(function()
  local miniclue = require('mini.clue')
  --stylua: ignore
  miniclue.setup({
    clues = {
      Config.leader_group_clues,
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.square_brackets(),
      miniclue.gen_clues.windows({ submode_resize = true }),
      miniclue.gen_clues.z(),
    },
    triggers = {
      { mode = { 'n', 'x' }, keys = '<Leader>' }, -- Leader triggers
      { mode =   'n',        keys = '\\' },       -- mini.basics
      { mode = { 'n', 'x' }, keys = '[' },        -- mini.bracketed
      { mode = { 'n', 'x' }, keys = ']' },
      { mode =   'i',        keys = '<C-x>' },    -- Built-in completion
      { mode = { 'n', 'x' }, keys = 'g' },        -- `g` key
      { mode = { 'n', 'x' }, keys = "'" },        -- Marks
      { mode = { 'n', 'x' }, keys = '`' },
      { mode = { 'n', 'x' }, keys = '"' },        -- Registers
      { mode = { 'i', 'c' }, keys = '<C-r>' },
      { mode =   'n',        keys = '<C-w>' },    -- Window commands
      { mode = { 'n', 'x' }, keys = 's' },        -- `s` key
      { mode = { 'n', 'x' }, keys = 'z' },        -- `z` key
    },
  })
end)

later(function() require('mini.cmdline').setup() end)

later(function() require('mini.comment').setup() end)

later(function() require('mini.cursorword').setup() end)

later(function() require('mini.diff').setup() end)

later(function() require('mini.doc').setup() end)

later(function() require('mini.git').setup() end)

later(function()
  local hipatterns = require('mini.hipatterns')
  local hi_words = MiniExtra.gen_highlighter.words
  hipatterns.setup({
    highlighters = {
      todo = { pattern = '%f[%w]()TODO:()', group = 'MiniHipatternsTodo' },
      note = { pattern = '%f[%w]()NOTE:()', group = 'MiniHipatternsNote' },
      hack = { pattern = '%f[%w]()HACK:()', group = 'MiniHipatternsHack' },
      fixme = { pattern = '%f[%w]()FIXME:()', group = 'MiniHipatternsFixme' },
      bug = { pattern = '%f[%w]()BUG:()', group = 'MiniHipatternsFixme' },
      warning = { pattern = '%f[%w]()WARNING:()', group = 'MiniHipatternsHack' },

      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  })
end)

later(
  function()
    require('mini.pairs').setup({
      modes = { insert = true, command = true, terminal = false },
    })
  end
)

later(function()
  require('mini.pick').setup()
  vim.keymap.set(
    'n',
    ',',
    '<Cmd>Pick buf_lines scope="current" preserve_order=true<CR>',
    { nowait = true }
  )

  MiniPick.registry.projects = function()
    local cwd = vim.fn.expand('~/Desktop/projects')
    local choose = function(item)
      vim.schedule(
        function() MiniPick.builtin.files(nil, { source = { cwd = item.path } }) end
      )
    end
    return MiniExtra.pickers.explorer({ cwd = cwd }, { source = { choose = choose } })
  end
end)

-- mini.files
local MiniFiles = require('mini.files')

vim.keymap.set('n', '\\', function()
  local buf_name = vim.api.nvim_buf_get_name(0)
  local path = vim.fn.filereadable(buf_name) == 1 and buf_name or vim.fn.getcwd()
  if not MiniFiles.close() then
    MiniFiles.open(path)
    MiniFiles.reveal_cwd()
  end
end, { desc = 'Toggle mini.files' })

later(function() require('mini.jump').setup() end)

later(function() require('mini.splitjoin').setup() end)

later(function() require('mini.surround').setup() end)

later(function() require('mini.test').setup() end)

later(function() require('mini.trailspace').setup() end)

later(function() require('mini.visits').setup() end)

-- Custom keymaps
vim.api.nvim_set_hl(0, 'MiniPickTargetLine', {
  fg = '#FFA066', -- Kanagawa orange
  bold = true,
  underline = true,
  force = true,
})

-- f is for 'Fuzzy find'
vim.keymap.set(
  'n',
  '<leader>ff',
  function() require('mini.pick').builtin.files() end,
  { desc = 'Find Files' }
)
vim.keymap.set(
  'n',
  '<leader>fg',
  function() require('mini.pick').builtin.grep_live() end,
  { desc = 'Live Grep' }
)

-- Custom Functions

_G.get_all_indent_lines = function()
  local res, lines = {}, vim.api.nvim_buf_get_lines(0, 0, -1, false)
  for i = 1, #lines do
    local indent = lines[i]:match('^%s+')
    if indent ~= nil then table.insert(res, indent) end
  end
  return res
end

_G.get_all_indent_text = function()
  local res, n = {}, vim.api.nvim_buf_line_count(0)
  local get_text = vim.api.nvim_buf_get_text
  for i = 1, n do
    local first_byte = get_text(0, i - 1, 0, i - 1, 1, {})[1]
    if first_byte == '\t' or first_byte == ' ' then
      table.insert(res, vim.fn.getline(i):match('^%s+'))
    end
  end
  return res
end

-- Unfortunately, `_lines` is 10x faster
_G.get_maxwidth_lines = function()
  local res, lines = 0, vim.api.nvim_buf_get_lines(0, 0, -1, false)
  for i = 1, #lines do
    res = res < lines[i]:len() and lines[i]:len() or res
  end
  return res
end

_G.get_maxwidth_bytes = function()
  local res, n = 0, vim.api.nvim_buf_line_count(0)
  local cur_byte, line2byte = 1, vim.fn.line2byte
  for i = 2, n + 1 do
    local new_byte = line2byte(i)
    res = math.max(res, new_byte - cur_byte)
    cur_byte = new_byte
  end
  return res - 1
end

-- Custom Auto Commands =======================================================

-- for mini.pick
vim.api.nvim_set_hl(
  0,
  'MiniPickMatchCurrent',
  { fg = '#E56B1A', bold = true, bg = 'NONE' }
)
