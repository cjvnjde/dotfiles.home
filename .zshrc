export XDG_CONFIG_HOME="$HOME/.config"
export ZSH="$HOME/.oh-my-zsh"

export BAT_THEME="Catppuccin Mocha"

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

plugins=(git docker bun node rust python)

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

if command -v eza >/dev/null 2>&1; then
  alias ls="eza --tree --level=0 --icons=always"
else
  alias ls="ls -G" 
fi

if command -v bat >/dev/null 2>&1; then
  alias cat="bat -p --theme='Catppuccin Mocha'"
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
  alias cd="z"
  alias ci="zi" 
fi

if command -v thefuck >/dev/null 2>&1; then
  eval "$(thefuck --alias)"
fi


alias h='eval "$(fc -l -r -n 1 | fzf)"'

if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh)"
fi

