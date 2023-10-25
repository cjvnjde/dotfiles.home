export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="bira"

plugins=(git autojump)

source $ZSH/oh-my-zsh.sh

. "$HOME/.asdf/asdf.sh"

fpath=(${ASDF_DIR}/completions $fpath)

autoload -Uz compinit && compinit

if [ -f "$HOME/.zshrc_local" ]; then
    source "$HOME/.zshrc_local"
fi

