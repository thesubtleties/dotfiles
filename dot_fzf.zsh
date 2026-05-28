# Setup fzf
# ---------
if [[ ! "$PATH" == */home/steven/.fzf/bin* ]]; then
  PATH="/home/steven/.fzf/bin${PATH:+:${PATH}}"
fi

source <(fzf --zsh)
