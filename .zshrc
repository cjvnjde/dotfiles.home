export XDG_CONFIG_HOME="$HOME/.config"
export ZSH="$HOME/.oh-my-zsh"

export EDITOR='nvim'
export VISUAL='nvim'

# FZF theme 
export FZF_DEFAULT_OPTS='
--height 40%
--layout=reverse
--border
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8,fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc,marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
--prompt="Search> "
--pointer=">"
'

path+=("$HOME/.local/scripts")
path+=("$HOME/.cargo/bin")

ZSH_THEME="bira"

plugins=(git asdf docker fzf node-bin bun git node rust zoxide)

source $ZSH/oh-my-zsh.sh

alias vim="nvim"
alias ls="eza --tree --level=1 --icons=always"
alias cd="z"
alias ci="zi"

if [ -f "$HOME/.zshrc_local" ]; then
    source "$HOME/.zshrc_local"
fi

eval "$(atuin init zsh)"

