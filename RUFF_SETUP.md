# Ruff Linter & Formatter Setup Guide

Ruff is an extremely fast Python linter and formatter, combining the functionality of:
- **Linting**: pylint, flake8, isort, and many others
- **Formatting**: black (code formatter)

## Installation

### Global Installation (Not Recommended)
```bash
# uv makes this easy
uv pip install ruff
```

### Project-Specific Installation (Recommended)
```bash
cd your-project
uv add --dev ruff
```

## Quick Start

### Check Code
```bash
# Lint entire project
uv run ruff check .

# Lint specific file
uv run ruff check myfile.py

# Show more details
uv run ruff check --show-source --show-fixes .
```

### Format Code
```bash
# Format all Python files
uv run ruff format .

# Format specific file
uv run ruff format myfile.py

# Check what would change (dry run)
uv run ruff check --fix --diff .
```

### Configuration via pyproject.toml

Create a `[tool.ruff]` section in your project's `pyproject.toml`:

```toml
[tool.ruff]
# Python version target
target-version = "3.9"

# Line length (Black default is 88)
line-length = 88

# Rules to enable
select = [
    "E",    # pycodestyle errors
    "W",    # pycodestyle warnings
    "F",    # Pyflakes
    "I",    # isort (import sorting)
    "B",    # flake8-bugbear
    "C4",   # flake8-comprehensions
    "UP",   # pyupgrade
]

# Rules to ignore
ignore = [
    "E501",  # Line too long (handled by formatter)
    "E203",  # Whitespace before ':'
    "W503",  # Line break before binary operator
]

# Directories to exclude
exclude = [
    ".git",
    ".venv",
    "__pycache__",
    "build",
    "dist",
]

# Per-file rule ignores
[tool.ruff.per-file-ignores]
"__init__.py" = ["F401"]  # Imported but unused
"tests/**" = ["F841"]     # Local variable assigned but never used
```

## Rule Sets (Linting Rules)

Ruff supports rule codes organized by prefix:

| Prefix | Tool | Examples |
|--------|------|----------|
| E/W | pycodestyle | E501 (line too long), W291 (trailing space) |
| F | Pyflakes | F841 (unused variable), F401 (unused import) |
| I | isort | I001 (import sorting) |
| B | flake8-bugbear | B008 (function call in default argument) |
| C4 | flake8-comprehensions | C400 (unnecessary generator) |
| UP | pyupgrade | UP009 (upgrade syntax) |
| RUF | Ruff-specific | RUF100 (unused noqa comment) |

See [Ruff Rules Reference](https://docs.astral.sh/ruff/rules/) for complete list.

## Formatting vs Linting

- **Linting** (ruff check): Finds code quality issues
- **Formatting** (ruff format): Auto-fixes style issues
- Some fixes can be applied automatically: `ruff check --fix .`

### Fixing Issues Automatically
```bash
# Auto-fix all fixable issues
uv run ruff check --fix .

# Show what would be fixed
uv run ruff check --fix --diff .

# Format code
uv run ruff format .

# Full pipeline
uv run ruff check --fix .
uv run ruff format .
```

## Integration with Vim/Neovim

### Option 1: Manual Command (Vim)
```vim
" Add to ~/.vimrc
" Format buffer with ruff
command! RuffFormat silent execute '!cd %:h && uv run ruff format %'
nnoremap <leader>rf :RuffFormat<CR>

" Check with ruff
command! RuffCheck silent execute '!cd %:h && uv run ruff check %'
nnoremap <leader>rc :RuffCheck<CR>
```

### Option 2: LSP Integration (Neovim - Recommended)

Using `conform.nvim` for formatting:

```lua
-- ~/.config/nvim/init.lua
require('conform').setup {
    formatters_by_ft = {
        python = { 'ruff_format' },
    },
    format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
    },
}
```

Using null-ls for linting (deprecated, use `nvim-lint` instead):

```lua
-- ~/.config/nvim/init.lua
require('nvim-lint').linters_by_ft = {
    python = { 'ruff' },
}
```

## GitHub Actions CI/CD Example

Add to `.github/workflows/lint.yml`:

```yaml
name: Lint & Format Check

on: [push, pull_request]

jobs:
  ruff:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: astral-sh/setup-uv@v1
      - run: uv sync
      - run: uv run ruff check .
      - run: uv run ruff format --check .
```

## Comparison: ruff vs Black vs pylint

| Feature | ruff | black | pylint |
|---------|------|-------|--------|
| **Speed** | Very Fast ✓ | Fast | Slow |
| **Formatting** | Yes | Yes (expert) | No |
| **Linting** | Yes (many rules) | No | Yes (verbose) |
| **Configuration** | Minimal | Minimal | Complex |
| **Import sorting** | Yes (via isort) | No | No |
| **Memory usage** | Low | Medium | High |

**Recommendation**: Use ruff for both linting and formatting (replaces Black + pylint)

## Pre-commit Hook

Automatically run ruff before commits:

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.1.0  # Use latest version
    hooks:
      - id: ruff
        args: [ --fix ]
      - id: ruff-format
```

Install: `pip install pre-commit && pre-commit install`

## Best Practices

1. **Use project-specific config**: `pyproject.toml` in project root
2. **Enable auto-fix in CI**: Helps catch style issues early
3. **Match team standards**: Configure rules to match your team's preferences
4. **Combine with formatting**: Use `ruff format` + `ruff check`
5. **Version pin in CI**: Specify `ruff==0.X.Y` in requirements to avoid diffs

## Troubleshooting

**"ruff: command not found"**
```bash
# Install globally
uv pip install ruff

# Or use via uv in project
cd your-project
uv add --dev ruff
uv run ruff --version
```

**Fixing "line too long" errors**
- Use `ruff format` to auto-fix
- Or adjust `line-length` in pyproject.toml

**Import sorting not working**
- Enable "I" rules: `select = ["I"]`
- Or use: `ruff check --select I --fix .`

## Resources

- [Ruff Documentation](https://docs.astral.sh/ruff/)
- [Ruff GitHub](https://github.com/astral-sh/ruff)
- [PEP 8 Style Guide](https://www.python.org/dev/peps/pep-0008/)
- [Black Code Formatter](https://black.readthedocs.io/)
