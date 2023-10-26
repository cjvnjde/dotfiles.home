export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="bira"

plugins=(git autojump asdf)

source $ZSH/oh-my-zsh.sh

if [ -f "$HOME/.zshrc_local" ]; then
    source "$HOME/.zshrc_local"
fi

