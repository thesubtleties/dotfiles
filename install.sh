#!/bin/bash
echo "Installing dotfiles..."

# Backup existing configs
mkdir -p ~/.dotfiles-backup
[ -f ~/.zshrc ] && mv ~/.zshrc ~/.dotfiles-backup/
[ -f ~/.gitconfig ] && mv ~/.gitconfig ~/.dotfiles-backup/
[ -f ~/.fzf.zsh ] && mv ~/.fzf.zsh ~/.dotfiles-backup/

# Create symlinks
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig  
ln -sf ~/dotfiles/.fzf.zsh ~/.fzf.zsh

echo "Dotfiles installed! Restart your shell or run: source ~/.zshrc"
