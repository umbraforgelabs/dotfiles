" Neovim Configuration
" Modern Lua-based configuration for Neovim
" Falls back to vimrc settings for basic compatibility

" For now, this file provides basic Neovim compatibility
" by sourcing the standard vimrc where possible.
"
" To fully modernize for Neovim:
" 1. Install a plugin manager (lazy.nvim recommended)
" 2. Create init.lua with full Lua configuration
" 3. Add LSP support with nvim-lspconfig
"
" Basic Neovim Settings
set number
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set textwidth=88
set ignorecase
set smartcase
set hlsearch
set incsearch

" Load Vim configuration for compatibility
" This allows using a shared vimrc between Vim and Neovim
if has('nvim')
    let s:home = fnamemodify(resolve(expand('<sfile>:p')), ':h')
    let s:vimrc_path = s:home . '/vimrc'
    if filereadable(s:vimrc_path)
        execute 'source ' . s:vimrc_path
    endif
endif

" === NEOVIM MODERNIZATION NOTES ===
"
" For advanced Neovim features, consider migrating to init.lua:
"
" 1. Install lazy.nvim plugin manager:
"    git clone --filter=blob:none --sparse https://github.com/folke/lazy.nvim.git ~/.local/share/nvim/lazy/lazy.nvim
"
" 2. Create ~/.config/nvim/init.lua with:
"    - lazy.nvim setup
"    - nvim-lspconfig for language servers
"    - nvim-treesitter for better syntax highlighting
"    - null-ls or conform.nvim for code formatting (ruff integration)
"
" 3. Add ruff formatting via null-ls or conform.nvim:
"    - This allows automatic Python formatting with ruff
"    - See RUFF_SETUP.md for configuration
"
" Resources:
" - Neovim docs: https://neovim.io
" - lazy.nvim: https://github.com/folke/lazy.nvim
" - nvim-lspconfig: https://github.com/neovim/nvim-lspconfig
" - conform.nvim: https://github.com/stevearc/conform.nvim
