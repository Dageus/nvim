local add = vim.pack.add
local now = Config.now

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
    extra_groups = {
      'NormalFloat',
      'MiniPickBorder',
      'FloatBorder',
      'CmpPmenu',
      'Pmenu',       -- The PUM background
      'PmenuBorder', -- The PUM border
      'PmenuThumb',  -- The scrollbar handle
    },
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
    force = true,                 -- Use force to override any plugin links
  })
end)
