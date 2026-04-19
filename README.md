# Modern Dotfiles Repository

Modern, multi-profile dotfiles configuration for Ubuntu 24.04 LTS with support for personal and work profiles. Includes GPG/Git setup, Python development toolchain (uv + ruff), Vim/Neovim configuration, and automated installation via GNU Stow.

**Latest Update**: April 2026 - Modernized for Python 3 with uv/ruff, updated GPG keyserver, and multi-profile support.

## Quick Start

```bash
# 1. Clone this repository to your forked version
cd /home/bill/Documents/dotfiles_ufl

# 2. Run installer
./install.sh

# 3. Follow post-installation instructions
```

## What's Included

### Directory Structure

```
dotfiles_ufl/
├── common/                    # Shared configurations
│   ├── bash_aliases          # Bash aliases (Python 3, uv)
│   ├── vimrc                 # Vim configuration
│   ├── init.vim              # Neovim configuration
│   ├── vim/                  # Vim colorschemes & syntax
│   │   ├── colors/           # 70+ base16 colorschemes
│   │   └── syntax/           # (empty - use plugin manager)
│   └── gnupg/                # GPG configuration (modern keyserver)
│       ├── gpg.conf          # GPG settings
│       ├── gpg-agent.conf    # GPG agent configuration
│       └── dirmngr.conf      # Directory manager config
├── profiles/
│   ├── personal/             # Personal profile
│   │   ├── gitconfig         # Personal Git credentials
│   │   └── bash_aliases_local
│   └── work/                 # Work profile
│       ├── gitconfig         # Work Git credentials
│       └── bash_aliases_local
├── install.sh                # Installation script
├── profile-selector.sh       # Profile switching script
├── gitconfig.template        # Git config template
├── UV_SETUP.md              # UV package manager guide
├── RUFF_SETUP.md            # Ruff linter/formatter guide
├── PLUGINS.md               # Vim/Neovim plugin setup
└── README.md                # This file
```

## Key Features

### 1. Multi-Profile Support

Switch between personal and work profiles with different Git credentials, emails, and GPG signing keys:

```bash
./profile-selector.sh personal    # Personal profile
./profile-selector.sh work        # Work profile
```

Each profile has:
- **Separate gitconfig** - Different name/email/signingkey
- **Profile-specific bash aliases** - Personal or work-specific commands
- **Shared common configs** - GPG, Vim, editor setup

### 2. Modern GPG Configuration

- **Updated keyserver**: `hkps://keys.openpgp.org` (replaced deprecated SKS network)
- **Ubuntu 24.04 LTS support**: Modern pinentry programs
- **Raspberry Pi OS support**: Tested on Bookworm
- **SSH support**: Optional gpg-agent SSH key management

See [common/gnupg/README.md](common/gnupg/README.md) for detailed setup.

### 3. Python Toolchain (uv + ruff)

Modern Python development tools:

- **uv**: Fast Python package installer/resolver (replaces pip, pipenv, poetry)
- **ruff**: Fast Python linter + formatter (replaces pylint, flake8, black)

Setup guides:
- [UV_SETUP.md](UV_SETUP.md) - Installation and quick start
- [RUFF_SETUP.md](RUFF_SETUP.md) - Configuration and integration

Quick example:
```bash
# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# Create new Python project
uv init my-project && cd my-project && uv sync

# Add dependencies
uv add requests
uv add --dev ruff pytest

# Run with environment
uv run python script.py

# Lint and format
uv run ruff check .
uv run ruff format .
```

### 4. Editor Configuration

#### Vim
- **Configuration**: [common/vimrc](common/vimrc)
- **Python support**: Optimized for Python 3 with 88-character width (Black format)
- **Syntax highlighting**: 70+ colorschemes included
- **Line highlighting**: Long lines (>80 chars) highlighted as warnings

#### Neovim
- **Configuration**: [common/init.vim](common/init.vim)
- **LSP support**: Setup guide in [PLUGINS.md](PLUGINS.md)
- **Modern plugins**: lazy.nvim, nvim-lspconfig, conform.nvim, nvim-lint
- **Integration**: Direct ruff formatting and linting

Setup plugins:
```bash
# Vim: Use vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Neovim: Use lazy.nvim (recommended)
# See PLUGINS.md for full setup
```

### 5. Git GPG Signing

Both profiles support commit and tag signing:

```bash
# Sign individual commit
git commit -S -m "Signed commit"

# Sign all commits (configured in gitconfig)
git commit -m "Auto-signed with GPG"

# Sign tags
git tag -s v1.0.0 -m "Signed release"
```

**Setup:**
1. Set `signingkey` in profile gitconfig
2. Ensure GPG key has correct UID/email
3. Test: `echo "test" | gpg --clearsign`

### 6. Automated Installation

**GNU Stow** manages all symlinks automatically:

```bash
./install.sh          # Interactive installation
./profile-selector.sh # Switch profiles
```

**What happens:**
- ✓ Backs up existing configs (timestamped)
- ✓ Creates symlinks for common configs
- ✓ Creates symlinks for selected profile
- ✓ Preserves git/gpg/bash history

## Installation

### Prerequisites

```bash
# Ubuntu 24.04 LTS
sudo apt update
sudo apt install stow git

# Optional but recommended
sudo apt install vim neovim
```

### Step 1: Clone Repository

```bash
cd /home/bill/Documents/
git clone <your-fork-url> dotfiles_ufl
cd dotfiles_ufl
```

### Step 2: Run Installer

```bash
./install.sh
```

Select profile (personal or work) when prompted.

### Step 3: Configure Git & GPG

Edit your profile's gitconfig:

```bash
# Edit ~/.gitconfig
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
git config --global user.signingkey 0xYOURKEYFINGERPRINT
```

Edit GPG settings:

```bash
# Edit ~/.gnupg/gpg.conf
# Set: default-key 0xYOURKEYFINGERPRINT

# Test GPG
gpg --refresh-keys
```

### Step 4: Install Python Tools (Optional)

```bash
# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# Verify installation
uv --version
```

### Step 5: Configure Editor (Optional)

**For Vim plugins:**
```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

**For Neovim (recommended):**
See [PLUGINS.md](PLUGINS.md) for lazy.nvim setup.

## Usage

### Switching Profiles

```bash
# Switch to personal profile
./profile-selector.sh personal

# Switch to work profile
./profile-selector.sh work

# Current Git configuration
git config --global user.name
git config --global user.email
```

### Bash Aliases

Available aliases (from [common/bash_aliases](common/bash_aliases)):

```bash
# Directory listing
ll           # ls -alF
lh           # ls -alFh with human-readable sizes
la           # ls -A

# System maintenance
update       # apt update + upgrade + dist-upgrade
cleanup      # Remove unused packages and clean cache

# Git & GPG
export GPG_TTY=$(tty)  # Auto-configured for GPG signing

# Python (uv)
uv init      # Create new project
uv sync      # Install dependencies
uv run       # Run in project environment
```

Add profile-specific aliases in:
- `~/.bash_aliases_local` (sourced after common aliases)
- `~/.bash_aliases_private` (private aliases, gitignored)

### Vim/Neovim

**Open file:**
```bash
vim ~/.vimrc       # Edit Vim config
nvim ~/.vimrc      # Or use Neovim
```

**Neovim with LSP (recommended for development):**
```bash
# See PLUGINS.md for full setup
# Quick setup: install lazy.nvim and add plugin specs
```

## Configuration Files

### GPG ([common/gnupg/](common/gnupg/))

| File | Purpose |
|------|---------|
| `gpg.conf` | GPG settings, keyserver, algorithms |
| `gpg-agent.conf` | Agent cache TTL, pinentry program |
| `dirmngr.conf` | Keyserver certificate config |

### Git ([profiles/{personal,work}/gitconfig](profiles/))

Template: [gitconfig.template](gitconfig.template)

Required fields:
- `[user] name` - Your full name
- `[user] email` - Your email address
- `[user] signingkey` - Your GPG key (0x format)
- `[commit] gpgsign` - Set to true to auto-sign commits

### Bash ([common/bash_aliases](common/bash_aliases))

Includes:
- Terminal color configuration
- GPG integration for git signing
- Directory listing aliases
- System maintenance helpers
- Python/uv documentation

## Modern Changes from Original

| Item | Old | New |
|------|-----|-----|
| **GPG Keyserver** | SKS network (deprecated) | `keys.openpgp.org` |
| **Pinentry** | Ubuntu 16.04 refs | Ubuntu 24.04 LTS + GUI support |
| **Python** | Python 2 references | Python 3 only |
| **Virtual Env** | virtualenvwrapper | uv (modern, fast) |
| **Linting** | None documented | ruff (fast, modern) |
| **Profiles** | Single config | Multi-profile support |
| **Installation** | Manual symlinks | GNU Stow automated |
| **Editors** | Vim only | Vim + Neovim |

## Troubleshooting

### Git not recognizing GPG key

```bash
# List keys
gpg --list-secret-keys --keyid-format=long

# Set key explicitly
git config --global user.signingkey 0xYOURKEY

# Test signing
echo "test" | gpg --clearsign
```

### GPG keyserver error

```bash
# Test keyserver connectivity
gpg --keyserver hkps://keys.openpgp.org --recv-keys 0xYOURKEYID

# If fails, check network and firewall
curl https://keys.openpgp.org
```

### Bash aliases not loading

```bash
# Add to ~/.bashrc if not present
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

# Reload shell
source ~/.bashrc
```

### Vim colorscheme not loading

```bash
# Ensure 256-color terminal
echo $TERM    # Should be xterm-256color or similar

# Test in vim
vim -c ':set t_Co=256' -c ':colorscheme solarized'
```

## Resources

- [UV Documentation](https://docs.astral.sh/uv/)
- [Ruff Documentation](https://docs.astral.sh/ruff/)
- [GNU Stow Manual](https://www.gnu.org/software/stow/manual/)
- [GPG Best Practices](https://riseup.net/en/security/message-security/openpgp/best-practices)
- [Neovim Configuration](https://neovim.io/doc/user/usr_01.html)
- [Vim Configuration Guide](https://dougblack.io/words/a-good-vimrc.html)

## Files Managed by Dotfiles

These files are managed by this dotfiles repository (symlinked):

```
~/.bashrc              → sources ~/.bash_aliases
~/.bash_aliases        → common/bash_aliases
~/.bash_aliases_local  → profiles/{profile}/bash_aliases_local
~/.gitconfig           → profiles/{profile}/gitconfig
~/.vimrc               → common/vimrc
~/.config/nvim/init.vim → common/init.vim
~/.gnupg/gpg.conf      → common/gnupg/gpg.conf
~/.gnupg/gpg-agent.conf → common/gnupg/gpg-agent.conf
~/.gnupg/dirmngr.conf  → common/gnupg/dirmngr.conf
~/.vim/colors/         → common/vim/colors/
```

## Contributing

To update dotfiles:

1. Edit files in the dotfiles_ufl directory
2. Test changes locally
3. Commit changes to git
4. Push to your fork

## License

These are personal dotfiles. Feel free to fork and customize for your needs.

## See Also

- [UV Setup Guide](UV_SETUP.md) - Python package manager
- [Ruff Setup Guide](RUFF_SETUP.md) - Linter & formatter
- [Plugin Manager Guide](PLUGINS.md) - Vim/Neovim plugins
- [GPG Configuration](common/gnupg/README.md) - GPG setup
- [Vim Configuration](common/vim/README.md) - Editor setup
  * @tpope for numerous useful repos
  * @webpro for [awesome-dotfiles](https://github.com/webpro/awesome-dotfiles)
  * @kdeldycke for [dotfiles](https://github.com/kdeldycke/dotfiles)
