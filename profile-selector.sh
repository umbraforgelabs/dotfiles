#!/bin/bash
# Profile Selector Script
# Switches between personal and work profiles by restowing symlinks

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HOME_DIR="$HOME"

# Validate profile argument
if [ $# -ne 1 ]; then
    echo -e "${BLUE}Profile Selector${NC}"
    echo "Usage: $0 <profile>"
    echo
    echo "Available profiles:"
    echo "  personal  - Personal profile"
    echo "  work      - Work profile"
    echo
    echo "Examples:"
    echo "  $0 personal"
    echo "  $0 work"
    exit 1
fi

PROFILE="$1"

# Check if profile exists
if [ ! -d "$SCRIPT_DIR/profiles/$PROFILE" ]; then
    echo -e "${RED}✗ Profile '$PROFILE' not found${NC}"
    echo "Available profiles:"
    ls -1 "$SCRIPT_DIR/profiles/"
    exit 1
fi

# Check if Stow is installed
if ! command -v stow &> /dev/null; then
    echo -e "${RED}✗ GNU Stow is not installed${NC}"
    echo "Install with: sudo apt install stow"
    exit 1
fi

echo -e "${BLUE}Switching to '$PROFILE' profile...${NC}"

# Unstow all profiles to remove old symlinks
echo -e "${YELLOW}Removing old profile symlinks...${NC}"
cd "$SCRIPT_DIR"
for profile_dir in profiles/*/; do
    profile_name=$(basename "$profile_dir")
    if [ -d "profiles/$profile_name" ]; then
        stow --no-folding --delete -t "$HOME_DIR" "profiles/$profile_name" 2>/dev/null || true
    fi
done

# Stow new profile
echo -e "${YELLOW}Installing $PROFILE profile symlinks...${NC}"
stow --no-folding -t "$HOME_DIR" "profiles/$PROFILE"

echo -e "${GREEN}✓ Switched to '$PROFILE' profile${NC}"
echo
echo -e "${YELLOW}Reminder:${NC}"
echo "  - Edit ~/.gitconfig with your credentials for this profile"
echo "  - Edit ~/.bash_aliases_local for profile-specific aliases"
echo

# Show profile status
echo -e "${BLUE}Current git configuration:${NC}"
if [ -f "$HOME_DIR/.gitconfig" ]; then
    echo "  User name: $(git config --global user.name 2>/dev/null || echo 'Not set')"
    echo "  User email: $(git config --global user.email 2>/dev/null || echo 'Not set')"
else
    echo "  No .gitconfig found (edit after switching profile)"
fi
