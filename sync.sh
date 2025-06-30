#!/bin/bash
# Bidirectional sync script for dotfiles

echo "Dotfiles Sync Tool"
echo "=================="

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Function to show usage
usage() {
    echo "Usage: $0 [push|pull|status]"
    echo ""
    echo "Commands:"
    echo "  push    - Update repository with current system dotfiles"
    echo "  pull    - Update system dotfiles from repository"
    echo "  status  - Show differences between system and repository"
    echo ""
    exit 1
}

# Function to compare files
compare_files() {
    local sys_file="$1"
    local repo_file="$2"
    local filename=$(basename "$sys_file")
    
    if [ -f "$sys_file" ] && [ -f "$repo_file" ]; then
        if ! diff -q "$sys_file" "$repo_file" > /dev/null; then
            echo -e "${YELLOW}Modified:${NC} $filename"
            echo "  Run 'diff $sys_file $repo_file' to see changes"
        else
            echo -e "${GREEN}In sync:${NC} $filename"
        fi
    elif [ -f "$sys_file" ] && [ ! -f "$repo_file" ]; then
        echo -e "${BLUE}Only on system:${NC} $filename"
    elif [ ! -f "$sys_file" ] && [ -f "$repo_file" ]; then
        echo -e "${RED}Only in repo:${NC} $filename"
    fi
}

# Define dotfiles to sync
DOTFILES=(
    ".zshrc"
    ".gitconfig"
    ".fzf.zsh"
)

# Add optional dotfiles if they exist
[ -f ~/.bashrc ] && DOTFILES+=(".bashrc")
[ -f ~/.vimrc ] && DOTFILES+=(".vimrc")
[ -f ~/.tmux.conf ] && DOTFILES+=(".tmux.conf")

case "$1" in
    push)
        echo -e "${BLUE}Pushing local changes to repository...${NC}"
        for file in "${DOTFILES[@]}"; do
            if [ -f ~/"$file" ]; then
                cp ~/"$file" ~/dotfiles/"$file"
                echo -e "${GREEN}✓${NC} Updated $file in repository"
            fi
        done
        cd ~/dotfiles && git status --short
        ;;
        
    pull)
        echo -e "${BLUE}Pulling repository changes to system...${NC}"
        echo -e "${YELLOW}Warning: This will overwrite your local dotfiles!${NC}"
        read -p "Continue? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            # Backup current files
            mkdir -p ~/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)
            for file in "${DOTFILES[@]}"; do
                if [ -f ~/"$file" ]; then
                    cp ~/"$file" ~/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)/"$file"
                fi
            done
            
            # Copy from repo
            for file in "${DOTFILES[@]}"; do
                if [ -f ~/dotfiles/"$file" ]; then
                    cp ~/dotfiles/"$file" ~/"$file"
                    echo -e "${GREEN}✓${NC} Updated $file on system"
                fi
            done
            echo -e "${GREEN}Backup saved in ~/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)${NC}"
        else
            echo "Cancelled."
        fi
        ;;
        
    status)
        echo -e "${BLUE}Comparing system files with repository...${NC}"
        echo ""
        for file in "${DOTFILES[@]}"; do
            compare_files ~/"$file" ~/dotfiles/"$file"
        done
        echo ""
        cd ~/dotfiles && git status --short
        ;;
        
    *)
        usage
        ;;
esac