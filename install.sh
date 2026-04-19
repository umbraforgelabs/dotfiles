#!/bin/bash
# Automated Dotfiles Installation Script
# Sets up multi-profile dotfiles using GNU Stow
# Supports personal and work profiles

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory (where dotfiles are located)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HOME_DIR="$HOME"

echo -e "${BLUE}=== Dotfiles Installation Script ===${NC}"
echo "Install location: $SCRIPT_DIR"
echo "Home directory: $HOME_DIR"
echo

# Check if Stow is installed
if ! command -v stow &> /dev/null; then
    echo -e "${YELLOW}⚠ GNU Stow not found. Installing...${NC}"
    sudo apt update
    sudo apt install -y stow
    echo -e "${GREEN}✓ Stow installed${NC}"
else
    echo -e "${GREEN}✓ GNU Stow found${NC}"
fi

echo

# Profile Selection
echo -e "${BLUE}Select profile to install:${NC}"
echo "1) Personal"
echo "2) Work"
echo -n "Enter choice (1 or 2): "
read -r profile_choice

case $profile_choice in
    1)
        PROFILE="personal"
        ;;
    2)
        PROFILE="work"
        ;;
    *)
        echo -e "${RED}✗ Invalid choice${NC}"
        exit 1
        ;;
esac

echo -e "${GREEN}✓ Selected profile: $PROFILE${NC}"
echo

# Backup existing configs
echo -e "${BLUE}Checking for existing configurations...${NC}"

backup_config() {
    local config="$1"
    local config_path="$HOME_DIR/$config"
    
    if [ -e "$config_path" ] && [ ! -L "$config_path" ]; then
        local backup_path="$HOME_DIR/${config}.backup.$(date +%Y%m%d_%H%M%S)"
        echo -e "${YELLOW}  Backing up existing $config to $backup_path${NC}"
        mv "$config_path" "$backup_path"
    fi
}

backup_config ".bashrc"
backup_config ".bash_aliases"
backup_config ".gitconfig"
backup_config ".vimrc"
backup_config ".config/nvim"
backup_config ".gnupg"

echo

# Install dotfiles using Stow
echo -e "${BLUE}Installing dotfiles...${NC}"

# Stow common configurations
echo -e "${YELLOW}  Stowing common configs...${NC}"
cd "$SCRIPT_DIR"
stow --no-folding -t "$HOME_DIR" common

# Stow profile-specific configurations
echo -e "${YELLOW}  Stowing $PROFILE profile...${NC}"
stow --no-folding -t "$HOME_DIR" "profiles/$PROFILE"

echo -e "${GREEN}✓ Dotfiles installed successfully${NC}"
echo

# Post-installation setup
echo -e "${BLUE}Post-installation setup:${NC}"
echo

# Git configuration
echo -e "${YELLOW}Git Configuration:${NC}"
echo "  1. Edit ~/.gitconfig with your details:"
echo "     - name: Your full name"
echo "     - email: Your email address"
echo "     - signingkey: Your GPG key fingerprint (0x...)"
echo

# GPG configuration
echo -e "${YELLOW}GPG Configuration:${NC}"
echo "  1. Edit ~/.gnupg/gpg.conf"
echo "     - Uncomment and set: default-key 0xYOURKEYFINGERPRINT"
echo "  2. Test GPG keyserver:"
echo "     gpg --keyserver hkps://keys.openpgp.org --recv-keys 0xYOURKEYID"
echo

# Bash aliases
echo -e "${YELLOW}Bash Configuration:${NC}"
echo "  1. Source bash_aliases in your ~/.bashrc (if not already done)"
echo "  2. Add to ~/.bashrc:"
echo "     if [ -f ~/.bash_aliases ]; then"
echo "         source ~/.bash_aliases"
echo "     fi"
echo "  3. Edit ~/.bash_aliases_local for $PROFILE-specific aliases"
echo

# Editor configuration
echo -e "${YELLOW}Editor Setup:${NC}"
echo "  1. Vim configuration: ~/.vimrc (already installed)"
echo "  2. Neovim configuration: ~/.config/nvim/init.vim (already installed)"
echo "  3. For advanced Neovim setup, see PLUGINS.md"
echo

# Python toolchain
echo -e "${YELLOW}Python Toolchain (uv + ruff):${NC}"
echo "  1. Install uv:"
echo "     curl -LsSf https://astral.sh/uv/install.sh | sh"
echo "  2. See UV_SETUP.md for uv quick start"
echo "  3. See RUFF_SETUP.md for ruff configuration"
echo

# Profile switching
echo -e "${YELLOW}Profile Switching:${NC}"
echo "  To switch to a different profile later:"
echo "     ./profile-selector.sh personal    # Switch to personal"
echo "     ./profile-selector.sh work        # Switch to work"
echo

# Final steps
echo -e "${BLUE}Next steps:${NC}"
echo "  1. Edit ~/.gitconfig with your Git credentials"
echo "  2. Edit ~/.gnupg/gpg.conf to set your default GPG key"
echo "  3. Edit ~/.bash_aliases_local for profile-specific aliases"
echo "  4. Source ~/.bash_aliases in ~/.bashrc (if needed)"
echo "  5. Install uv: https://docs.astral.sh/uv/installation/"
echo "  6. Restart your shell or run: source ~/.bashrc"
echo

echo -e "${GREEN}✓ Installation complete!${NC}"
echo
