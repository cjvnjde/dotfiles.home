export XDG_CONFIG_HOME="$HOME/.config"
export ZSH="$HOME/.oh-my-zsh"

export BAT_THEME="Catppuccin Mocha"

export FZF_DEFAULT_OPTS='
--height 40%
--layout=reverse
--border
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8,fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc,marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
--prompt="Search> "
--pointer=">"
'

typeset -U path PATH
path+=(
  "$HOME/.local/scripts"
  "$HOME/.local/bin"
  "$HOME/.cargo/bin"
)

ZSH_THEME="bira"

plugins=(git docker colored-man-pages zsh-autosuggestions zsh-syntax-highlighting)

source "$ZSH/oh-my-zsh.sh"

alias h='eval "$(fc -l -r -n 1 | fzf)"'
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh)"
fi

if [[ -f "$HOME/.zshrc_local" ]]; then
  source "$HOME/.zshrc_local"
fi
