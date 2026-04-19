# Vim/Neovim Editor Configuration

This directory contains editor configuration for both Vim and Neovim.

## Files

### `vimrc`
Main Vim configuration file, compatible with Vim 8.0+
- Solarized colorscheme
- Python development optimizations (88-char line width for Black)
- Long line highlighting for code standards
- Support for C/C++, Python, TeX/LaTeX

### `init.vim`
Neovim configuration (falls back to vimrc for basic settings)
- Provides Neovim-specific enhancements
- Can be extended with Lua-based configuration
- Includes notes for modern plugin setup

### `colors/`
Vim colorscheme files (70+ base16 themes included from original dotfiles)
- Solarized (default in vimrc)
- Base16 themes for customization

### `syntax/`
Syntax highlighting files (initially empty)
- Recommended: Use a plugin manager instead of static files
- See PLUGINS.md for plugin manager setup

## Quick Start

1. Copy `vimrc` to `~/.vimrc`
2. Copy `init.vim` to `~/.config/nvim/init.vim` (for Neovim)
3. Copy `colors/` directory contents to `~/.vim/colors/`

## Python Development

### Black Integration (88-character width)
- Python files use 88-character textwidth (matches Black formatter)
- Lines > 80 characters highlighted as warnings

### Ruff Linting & Formatting
- See `../RUFF_SETUP.md` for ruff integration with Vim/Neovim LSP
- Consider using LSP plugins for real-time feedback

### Recommended Plugins

**For Vim:**
- vim-plug: Simple plugin manager
- coc.nvim: IntelliSense for Python
- vim-ruff: Direct Ruff integration

**For Neovim (recommended for modern development):**
- lazy.nvim: Modern plugin manager
- nvim-lspconfig: LSP client setup
- conform.nvim: Formatter integration (ruff)
- nvim-treesitter: Better syntax highlighting

See `../PLUGINS.md` for detailed setup instructions.

## Configuration Priority

1. **Vim**: Uses `~/.vimrc`
2. **Neovim**: Uses `~/.config/nvim/init.vim` (includes vimrc fallback)
3. **Modern Neovim**: Uses `~/.config/nvim/init.lua` (not included, but recommended for advanced features)

## Troubleshooting

**Python syntax not highlighting correctly:**
- Check vim version: `vim --version | grep +python`
- Install Python support: `sudo apt install vim-python3`

**Colors not loading:**
- Ensure 256-color terminal: `echo $TERM` (should be `xterm-256color` or similar)
- Test: `vim -c ':colorscheme solarized'`

**Neovim configuration not loading:**
- Check config path: `nvim -c ':set runtimepath?'`
- Ensure `~/.config/nvim/init.vim` exists

## Migrating to Modern Neovim (Optional)

For advanced development workflows, consider migrating to Lua-based Neovim configuration:

```bash
# 1. Install lazy.nvim
git clone --filter=blob:none --sparse https://github.com/folke/lazy.nvim.git ~/.local/share/nvim/lazy/lazy.nvim

# 2. Create Lua configuration
mkdir -p ~/.config/nvim
# Create init.lua and plugin specs

# 3. Install plugins
nvim
```

See `../PLUGINS.md` for full Lua setup guide.
