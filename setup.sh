#!/bin/bash
echo "Setting up development environment..."

# Update system
sudo apt update

# Install essential packages (note: NO fzf from apt)
sudo apt install -y \
    zsh git curl wget \
    exa bat fd-find ripgrep \
    htop ncdu jq zoxide

# Remove fzf if it was installed via apt (to avoid conflicts)
sudo apt remove fzf -y 2>/dev/null || true

# Install fzf from source (newer version with --zsh support)
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

echo "Setup complete! Now run: ./install.sh"
