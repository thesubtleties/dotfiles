#!/bin/bash
echo "Setting up development environment..."

# Update system
sudo apt update

# Install essential packages (note: NO fzf from apt)
sudo apt install -y \
    zsh git curl wget \
    bat fd-find ripgrep \
    htop ncdu jq zoxide

# Install modern ls replacement (try eza first, fallback to exa)
if ! command -v eza &> /dev/null && ! command -v exa &> /dev/null; then
    echo "Installing modern ls replacement..."
    # Try eza first
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg 2>/dev/null || true
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list 2>/dev/null || true
    sudo apt update && sudo apt install eza -y || {
        # Fallback to exa if available
        sudo add-apt-repository universe -y 2>/dev/null || true
        sudo apt update && sudo apt install exa -y || echo "Could not install eza or exa, will use regular ls"
    }
fi

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
