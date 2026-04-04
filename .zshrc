export XDG_CONFIG_HOME="$HOME/.config"
export ZSH="$HOME/.oh-my-zsh"

export FZF_DEFAULT_OPTS='
--height 40%
--layout=reverse
--border
--prompt="Search> "
--pointer=">"
'

path+=("$HOME/.local/scripts")
path+=("$HOME/.local/bin")
path+=("$HOME/.cargo/bin")

ZSH_THEME="bira"

autoload -Uz compinit

if [[ -n "$HOME/.zcompdump"(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

plugins=(git docker colored-man-pages zsh-autosuggestions zsh-syntax-highlighting)

DISABLE_COMPFIX="true"
source $ZSH/oh-my-zsh.sh

if [ -f "$HOME/.zshrc_local" ]; then
    source "$HOME/.zshrc_local"
fi

if command -v nvim >/dev/null 2>&1; then
  alias vim="nvim"

  export EDITOR='nvim'
  export VISUAL='nvim'
else
  export EDITOR='vim'
  export VISUAL='vim'
fi

alias h='eval "$(fc -l -r -n 1 | fzf)"'
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"

# Deferred init: runs after the prompt is displayed and zle is idle.
# Requires custom OMZ plugins (see home/README.md):
#   - zsh-syntax-highlighting
#   - zsh-autosuggestions
#   - zsh-defer
source ${ZSH_CUSTOM:-$ZSH/custom}/plugins/zsh-defer/zsh-defer.plugin.zsh

zsh-defer -c 'command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)" && alias cd="z" && alias ci="zi"'
zsh-defer -c 'command -v atuin  >/dev/null 2>&1 && eval "$(atuin init zsh)"'
