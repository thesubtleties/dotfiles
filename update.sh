#!/bin/bash
# Script to update dotfiles repository with current system configurations

echo "Updating dotfiles repository with current configurations..."

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to copy and check differences
update_file() {
    local source="$1"
    local dest="$2"
    local filename=$(basename "$source")
    
    if [ -f "$source" ]; then
        if [ -f "$dest" ]; then
            if ! diff -q "$source" "$dest" > /dev/null; then
                echo -e "${YELLOW}Updating${NC} $filename"
                cp "$source" "$dest"
            else
                echo -e "${GREEN}No changes${NC} in $filename"
            fi
        else
            echo -e "${GREEN}Adding${NC} $filename"
            cp "$source" "$dest"
        fi
    else
        echo -e "${RED}Warning:${NC} $source not found"
    fi
}

# Update main dotfiles
update_file ~/.zshrc ~/dotfiles/.zshrc
update_file ~/.gitconfig ~/dotfiles/.gitconfig
update_file ~/.fzf.zsh ~/dotfiles/.fzf.zsh

# Optional: Update other common dotfiles if they exist
[ -f ~/.bashrc ] && update_file ~/.bashrc ~/dotfiles/.bashrc
[ -f ~/.vimrc ] && update_file ~/.vimrc ~/dotfiles/.vimrc
[ -f ~/.tmux.conf ] && update_file ~/.tmux.conf ~/dotfiles/.tmux.conf

# Show git status
echo ""
echo "Git status:"
cd ~/dotfiles && git status --short

echo ""
echo "Update complete! Review changes with: cd ~/dotfiles && git diff"
echo "To commit: cd ~/dotfiles && git add . && git commit -m 'Update dotfiles'"