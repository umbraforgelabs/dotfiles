# UV Package Manager Setup Guide

`uv` is a fast, Rust-based Python package installer and resolver that replaces pip, pipenv, and poetry for modern Python development.

## Installation

### Ubuntu 24.04 LTS

**Option 1: Via apt (Recommended)**
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

**Option 2: Via pip**
```bash
pip install uv
```

**Option 3: Via Homebrew (if available)**
```bash
brew install uv
```

### Verify Installation
```bash
uv --version
# Output: uv 0.X.X
```

## Quick Start

### Initialize a New Python Project
```bash
# Create new project with template
uv init my-project
cd my-project

# This creates:
# - pyproject.toml (project configuration)
# - .python-version (Python version specification)
# - hello.py (starter script)
# - .venv/ (virtual environment)
```

### Install Dependencies
```bash
# Install from pyproject.toml
uv sync

# Add a new dependency
uv add requests

# Add a dev dependency
uv add --dev pytest ruff

# Remove a dependency
uv remove requests
```

### Run Python Scripts
```bash
# Run script in project environment
uv run hello.py

# Run Python REPL
uv run python

# Run arbitrary command
uv run pip list
```

### Manage Python Versions
```bash
# Install specific Python version
uv python install 3.12

# Use specific version in project
echo "3.12" > .python-version
uv sync  # Re-syncs with new Python version

# List available versions
uv python list
```

## Integration with Bash

The `bash_aliases` file includes uv documentation and path setup. No additional configuration needed if installed globally.

### Common Patterns

```bash
# Create new project and sync
uv init my-project && cd my-project && uv sync

# Install and run a CLI tool
uv run --with black black --check .

# Run tests
uv run pytest

# Interactive development shell
uv run python
```

## Migrating Existing Projects to UV

### From pip + requirements.txt
```bash
# 1. Initialize uv project
uv init

# 2. Convert requirements.txt to pyproject.toml
#    Manual: Edit pyproject.toml [project] dependencies section
#    Or: Use uv add for each dependency
uv add $(cat requirements.txt | grep -v '^#' | tr '\n' ' ')

# 3. Remove old files (optional)
rm -f requirements.txt venv/ .python-version
```

### From virtualenv
```bash
# 1. Create uv project
uv init

# 2. Migrate dependencies
# Find your virtualenv directory
source /path/to/old/.venv/bin/activate
pip freeze > /tmp/requirements.txt
deactivate

# 3. Add to uv
uv add $(cat /tmp/requirements.txt | grep -v '^#' | tr '\n' ' ')
```

### From pipenv
```bash
# 1. Create uv project
uv init

# 2. Export pipenv dependencies
pipenv requirements > /tmp/requirements.txt
pipenv requirements --dev >> /tmp/requirements-dev.txt

# 3. Add to uv
uv add $(cat /tmp/requirements.txt | tr '\n' ' ')
uv add --dev $(cat /tmp/requirements-dev.txt | tr '\n' ' ')
```

## Configuration

### pyproject.toml

The main configuration file for uv projects:

```toml
[project]
name = "my-project"
version = "0.1.0"
description = "My awesome project"
requires-python = ">=3.9"
dependencies = [
    "requests>=2.28",
    "click>=8.1",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.0",
    "ruff>=0.1",
    "black>=23.0",
]

[tool.uv]
# UV-specific settings
dev-dependencies = []
```

### .python-version

Specifies the Python version for the project:

```
3.12
```

Run `uv python install 3.12` if needed, then `uv sync` to update.

## Integration with Ruff

uv and ruff work seamlessly together:

```bash
# Install ruff in project
uv add --dev ruff

# Run ruff checks
uv run ruff check .

# Run ruff formatting
uv run ruff format .

# Combined with Black
uv add --dev black
uv run black .
uv run ruff check .
```

See `RUFF_SETUP.md` for detailed ruff configuration.

## Best Practices

1. **Use .python-version**: Specify exact Python version for reproducibility
2. **Commit pyproject.toml and .python-version**: Track in git
3. **Don't commit .venv/**: Add to .gitignore
4. **Use dev dependencies**: Keep prod dependencies lean
5. **Run linting before commits**: `uv run ruff check . && uv run black .`

## Troubleshooting

**"Python X.Y not found"**
```bash
uv python install 3.12  # Install the version you need
```

**"ModuleNotFoundError" when running scripts**
```bash
# Make sure you're using `uv run`
uv run my-script.py  # ✓ Correct
python my-script.py  # ✗ Wrong (uses system Python)
```

**Performance issues with large projects**
```bash
# uv caches packages - if issues persist, clear cache:
uv cache prune
```

## Resources

- [UV Documentation](https://docs.astral.sh/uv/)
- [UV GitHub Repository](https://github.com/astral-sh/uv)
- [Python Packaging Guide](https://packaging.python.org/)
- [Poetry (alternative)](https://python-poetry.org/)
