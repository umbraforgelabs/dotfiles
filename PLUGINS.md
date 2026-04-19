# Vim/Neovim Plugin Manager Setup Guide

This guide covers setting up modern plugin managers and LSP (Language Server Protocol) support for Python development with Vim and Neovim.

## Quick Comparison

| Feature | vim-plug | Pathogen | native packages | lazy.nvim |
|---------|----------|----------|-----------------|-----------|
| **Ease** | Easy | Medium | Hard | Easy |
| **Speed** | Fast | Medium | N/A | Fast |
| **Vim Support** | ✓ | ✓ | ✓ | ✗ (Neovim only) |
| **Neovim Support** | ✓ | ✓ | ✓ | ✓ |
| **Async Loading** | ✓ | ✗ | ✗ | ✓ |
| **Lazy Loading** | ✓ | ✗ | ✗ | ✓ |

---

## For Vim Users

### Option 1: vim-plug (Recommended for Vim)

#### Installation
```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

#### Configuration
Create `~/.vimrc` with:
```vim
" Vim-Plug: Start plugins section
call plug#begin('~/.vim/plugged')

" Python Linting / Formatting
Plug 'astral-sh/ruff.vim'

" Code completion (requires build tools)
Plug 'ycm-core/YouCompleteMe', { 'do': './install.py --clang-completer' }

" Syntax highlighting enhancement
Plug 'vim-python/vim-python-pep8-indent'

" File explorer
Plug 'preservim/nerdtree'

" Status line
Plug 'vim-airline/vim-airline'

call plug#end()

" === Ruff Configuration ===
let g:ruff_autofixable = 1
nmap <leader>rk <Plug>(ruff-quickfix)

" === Other settings from main vimrc ===
" ... rest of your vimrc ...
```

#### Usage
```bash
# Install plugins
vim +PlugInstall +qall

# Update plugins
vim +PlugUpdate +qall

# Remove plugins (delete from config, then run)
vim +PlugClean +qall
```

---

## For Neovim Users (Recommended)

### Setup: lazy.nvim

lazy.nvim is the modern plugin manager for Neovim, with excellent performance and async loading.

#### Installation

```bash
# 1. Create config directory
mkdir -p ~/.config/nvim

# 2. Install lazy.nvim
git clone --filter=blob:none --sparse https://github.com/folke/lazy.nvim.git ~/.local/share/nvim/lazy/lazy.nvim --branch=stable

# 3. Create basic init.lua
cat > ~/.config/nvim/init.lua << 'EOF'
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup("plugins", {
  defaults = { lazy = false },
})
EOF
```

#### Create Plugin Specifications

```bash
mkdir -p ~/.config/nvim/lua/plugins
```

Create `~/.config/nvim/lua/plugins/init.lua`:

```lua
return {
  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lspconfig = require('lspconfig')
      
      -- Python LSP (Pylance recommended, or Pyright)
      lspconfig.pylance.setup{}
      
      -- Optional: Pyright (lighter alternative)
      -- lspconfig.pyright.setup{}
    end,
  },
  
  -- Code Formatting with Ruff
  {
    "stevearc/conform.nvim",
    lazy = true,
    event = { "BufWritePre" },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          python = { "ruff_format" },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })
    end,
  },
  
  -- Linting with Ruff
  {
    "mfussenegger/nvim-lint",
    lazy = true,
    event = { "BufReadPost", "BufWritePost" },
    config = function()
      require("lint").linters_by_ft = {
        python = { "ruff" },
      }
      
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
  
  -- Treesitter for better syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = true,
    event = "BufRead",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "python", "bash", "c", "lua", "markdown" },
        highlight = { enable = true },
      })
    end,
  },
  
  -- Completion
  {
    "hrsh7th/nvim-cmp",
    lazy = true,
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
        }),
      })
    end,
  },
  
  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    config = function()
      require("nvim-tree").setup()
    end,
  },
}
```

#### Install & Update

```bash
# Start Neovim and install plugins
nvim

# Inside Neovim, run:
:Lazy install

# Update plugins:
:Lazy update
```

---

## Python LSP Servers

### Option 1: Pylance (Recommended, VS Code's Language Server)
```bash
uv pip install pylance
```

### Option 2: Pyright (Open-source, lighter)
```bash
uv pip install pyright
```

### Option 3: Python-LSP (Older, but configurable)
```bash
uv pip install python-lsp-server
```

---

## Essential Plugins for Python Development

### Neovim Minimal Setup (copy-paste ready)

```bash
mkdir -p ~/.config/nvim
```

Create `~/.config/nvim/init.lua`:

```lua
-- Minimal Neovim config for Python development
vim.opt.number = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.textwidth = 88

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "neovim/nvim-lspconfig" },
  { "stevearc/conform.nvim" },
  { "mfussenegger/nvim-lint" },
}, {})

-- Python LSP setup
local lspconfig = require('lspconfig')
lspconfig.pyright.setup{}

-- Formatting with ruff
local conform = require('conform')
conform.setup({
  formatters_by_ft = { python = { 'ruff_format' } },
  format_on_save = { timeout_ms = 500, lsp_fallback = true },
})

-- Linting with ruff
local lint = require('lint')
lint.linters_by_ft = { python = { 'ruff' } }
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function() lint.try_lint() end,
})
```

---

## Integration with uv + ruff

### Running Linter/Formatter from Editor

**Vim (with ruff.vim):**
```vim
" In vimrc
Plug 'astral-sh/ruff.vim'

" Keymaps
nnoremap <leader>rk <Plug>(ruff-quickfix)
nnoremap <leader>rf <Plug>(ruff-fix)
```

**Neovim (with conform.nvim):**
```lua
-- Auto-format on save (see configuration above)
-- Or manual format:
vim.keymap.set("n", "<leader>f", function()
  require("conform").format({ async = true, lsp_fallback = true })
end)
```

---

## Troubleshooting

**LSP not working in Neovim**
```bash
# Check LSP status
:LspInfo

# Install language server
pip install pyright

# Restart Neovim
```

**Formatting not working**
```bash
# Ensure ruff is installed in project
cd your-project && uv add --dev ruff

# Test ruff manually
uv run ruff format --check .
```

**Plugins not loading**
```bash
# Clear cache and reinstall
rm -rf ~/.local/share/nvim/lazy/
nvim +Lazy install +qall
```

---

## Recommended Reading

- [Neovim Configuration Guide](https://neovim.io/doc/user/)
- [lazy.nvim Documentation](https://github.com/folke/lazy.nvim)
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- [conform.nvim](https://github.com/stevearc/conform.nvim)
- [vim-plug vs Others](https://stackoverflow.com/questions/10732158)
