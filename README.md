# Dotfiles

Personal configuration files for my development environment.

## Quick Start

```bash
# Clone the repo
git clone [your-repo-url] ~/dotfiles
cd ~/dotfiles

# Install dotfiles to your system
./install.sh

# Or set up everything (packages + dotfiles)
./setup.sh
```

## Syncing Changes

```bash
# After editing dotfiles locally, push changes to repo
./sync.sh push
git add .
git commit -m "Update dotfiles"
git push

# Pull dotfiles from repo to system
./sync.sh pull

# Check differences
./sync.sh status
```

## Files Included

- `.zshrc` - Zsh configuration
- `.gitconfig` - Git configuration
- `.fzf.zsh` - Fuzzy finder configuration
- `.bashrc` - Bash configuration

## Scripts

- `install.sh` - Install dotfiles to system
- `setup.sh` - Full setup (packages + dotfiles)
- `sync.sh` - Sync dotfiles between system and repo
- `update.sh` - Update dotfiles from repo