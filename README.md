# NeoVim config

> [!NOTE]
> This config is very inspired by the [`mini.nvim`](https://github.com/nvim-mini/mini.nvim) library and [`MiniMax`](https://github.com/nvim-mini/MiniMax) "distro"
> creator [echasnovski](https://github.com/echasnovski/), who understands NeoVim a lot better than me.

This is my NeoVim setup, where most of the `mini` ecosystem is adopted for minimum latency.

## Prerequisites

- nvim >= 0.12

- Go

- npm

- cargo

- Python/pip

- A Nerd font

- ripgrep

> Contrary to echasnovski's config, I don't have backwards compatibility, relying solely on nvim >= 0.12, since it finally removed third-party package managers and unnecessary bloat in favor of `vim.pack`

## File Structure

```
├── init.lua           # Global settings, Config helpers
└── plugin
    ├── 10_options.lua
    ├── 20_keymaps.lua
    ├── 21_functions.lua
    ├── 30_mini.lua
    └── 40_plugins.lua
```

## Colorscheme

My one and only love [kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim)

## LSP's

Some of the LSP's I use may not be the standard but are by far the fastest:

- **Python**: all of [astral-sh](https://github.com/astral-sh/)'s tools are used in my development, due to how performant they are

- **Typescript**: [vstls](https://github.com/yioneko/vtsls) since it really shines on large projects

- Other sources are industry standards.
