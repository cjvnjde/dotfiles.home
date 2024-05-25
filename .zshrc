export XDG_CONFIG_HOME="$HOME/.config"
export ZSH="$HOME/.oh-my-zsh"

export EDITOR='nvim'
export VISUAL='nvim'

path+=("$HOME/.local/scripts")
path+=("$HOME/.cargo/bin")

ZSH_THEME="bira"

plugins=(git autojump asdf npm docker tmux fzf node-bin)

bindkey -s ^f "tmux-sessionizer\n"

source $ZSH/oh-my-zsh.sh

if [ -f "$HOME/.zshrc_local" ]; then
    source "$HOME/.zshrc_local"
fi

alias vim="nvim"
alias ls="eza --tree --level=1 --icons=always"
