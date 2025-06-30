# Debug Zsh startup
#echo "Starting Zsh initialization at $(date)" >> ~/.zsh_debug_log

# pyenv configuration
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Oh My Zsh update behavior
zstyle ':omz:update' mode reminder
zstyle ':omz:plugins:alias-finder' autoload yes

# Plugins (combined list with your existing and Python-related plugins)
plugins=(
    git
    docker
    docker-compose
    node
    npm
    sudo
    aliases
    alias-finder
    zsh-autosuggestions
    zsh-syntax-highlighting
)
source $ZSH/oh-my-zsh.sh


# User configuration
# Ensure PATH includes user's private bins
[[ ":$PATH:" != *":$HOME/bin:"* ]] && PATH="$HOME/bin:$PATH"
[[ ":$PATH:" != *":$HOME/.local/bin:"* ]] && PATH="$HOME/.local/bin:$PATH"

# Source cargo env if it exists
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# Your existing aliases and functions
alias zshconfig="code ~/.zshrc"
alias backup_zsh='~/backup_dotfiles.sh'
alias lemmy='docker run --rm -it -e LEMMY_DOMAIN=reddthat.com -p "8080:8080" ghcr.io/rystaf/mlmmy:latest'
alias ptree='tree -C -I "node_modules|__pycache__|.git|.venv|venv|env|dist|build|.DS_Store|*.pyc|*.egg-info|.pytest_cache|.mypy_cache|target|*.log|htmlcov"'
alias cd="cd_function"
alias jobsearch='/home/steven/linkedin/linkedin_batch.sh'
alias zed="WAYLAND_DISPLAY='' zed "
alias rovodev="aclir rovodev run"

function cd_function() {
  builtin cd "$@" && exa --icons
}
alias sync-projects="~/sync-aa-projects.sh"
# Your existing prompt configuration
autoload -U colors && colors
setopt PROMPT_SUBST

PROMPT='%(?.%{$fg[green]%}➜.%{$fg[red]%}✘)%{$reset_color%} %{$fg[blue]%}%c%{$reset_color%} $(git_prompt_info)$ '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX=")%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="*"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Your existing PATH configurations
export PATH="/usr/local/bin:$PATH"
export PATH="/home/steven/.npm-global/bin:$PATH"

# NVM configuration
export NVM_DIR="$HOME/.nvm"

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Python Development Environment Setup
# Path configurations
export PATH="$PYENV_ROOT/bin:$PATH"
PATH=~/.console-ninja/.bin:$PATH


# pipenv configuration
export PIPENV_VENV_IN_PROJECT=1

# Python aliases
alias py='python'
alias ptest='pytest'
alias pr='pipenv run'
alias psh='pipenv shell'
alias pyc-clean='rm -rf **/*.pyc(N) **/__pycache__(N)'
alias pytest-clean='rm -rf **/.pytest_cache(N)'
alias py-clean='pyc-clean && pytest-clean'
alias pyfind='find . -name "*.py"(N) -not -path "*.venv*"'
alias pygrep='grep --include="*.py" -nr'

# Docker Compose aliases
alias dc='docker compose'
alias dcu='docker compose up'
alias dcud='docker compose up -d'
alias dcd='docker compose down'
alias dcps='docker compose ps'
alias dcl='docker compose logs'
alias dclf='docker compose logs -f'
alias dcr='docker compose restart'
alias dcp='docker compose pull'
alias dcb='docker compose build'
alias dcex='docker compose exec'
alias dcrm='docker compose rm'
alias dcst='docker compose stop'
alias dcim='docker compose images'

# Combined operations
alias dcudb='docker compose up -d --build'
alias dcdn='docker compose down --remove-orphans'
alias dcdr='docker compose down && docker compose up -d'
alias dcdv='docker compose down -v' # Down + remove volumes
alias dcprune='docker system prune -af' # Cleanup unused images/containers

alias ls="exa --icons"
alias ll="exa -l --icons" 
alias la="exa -la --icons"
alias tree="exa --tree --icons"

# ZSH-specific Python development settings
setopt EXTENDED_GLOB

# Python completions
autoload -Uz compinit && compinit
compdef _pip pip
compdef _python python

# Pipenv completion
_pipenv() {
  eval $(env COMMANDLINE="${words[1,$CURRENT]}" _PIPENV_COMPLETE=zsh_source pipenv)
}
compdef _pipenv pipenv

# Python helper functions


venvs() {
    print -P "%F{cyan}Virtual Environments:%f"
    ls -1 ~/.local/share/virtualenvs
}

workon() {
    local venv_path="$(pipenv --venv 2>/dev/null)"
    if [[ -n "$venv_path" ]]; then
        source "$venv_path/bin/activate"
    else
        print -P "%F{red}No virtual environment found in current directory%f"
    fi
}

function pynew {
    if [[ -z "$1" ]]; then
        print -P "%F{red}Usage: pynew project_name%f"
        return 1
    fi
    ~/scripts/create-python-project.sh "$1" && cd "$1" && pipenv shell
}

# Debug Zsh completion
#echo "Finished Zsh initialization at $(date)" >> ~/.zsh_debug_log
eval "$(pyenv init -)"
eval "$(zoxide init zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
