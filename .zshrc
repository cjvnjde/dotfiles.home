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

alias ff="fzf --preview 'bat --style=numbers --color=always {}'"

old() {
  if (( $# == 0 )); then
    print -u2 "usage: old <command> [args...]"
    return 2
  fi

  command "$@"
}

if command -v eza >/dev/null 2>&1; then
  alias ls="eza"
fi

if command -v fd >/dev/null 2>&1; then
  alias find="fd"
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
  alias cd="z"
fi

if command -v atuin >/dev/null 2>&1; then
  expected_atuin_key_hash="6c9af3da1bf495b8c7fdeb0e7734b3c53c55c0249c843988f5f0d8bb7fadfaa3"
  actual_atuin_key_hash="$(atuin key | sha256sum | awk '{print $1}')"

  if [[ "$actual_atuin_key_hash" == "$expected_atuin_key_hash" ]]; then
    eval "$(atuin init zsh)"
  else
    print -u2 "Atuin key mismatch — Atuin disabled"
  fi
fi

if [[ -f "$HOME/.zshrc_local" ]]; then
  source "$HOME/.zshrc_local"
fi
