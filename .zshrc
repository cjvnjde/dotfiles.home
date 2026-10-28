# Machine-specific paths and tool setup must be available to shared integrations.
if [[ -f "$HOME/.zshrc_local" ]]; then
  source "$HOME/.zshrc_local"
fi

export BAT_THEME="Catppuccin Mocha"

export FZF_DEFAULT_OPTS='
--height 40%
--layout=reverse
--border
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8,fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc,marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
--prompt="Search> "
--pointer=">"
'

ZSH_THEME="bira"

plugins=(git docker colored-man-pages zsh-autosuggestions zsh-syntax-highlighting)

if [[ -n "${ZSH:-}" && -f "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
fi

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

mkcd() {
  mkdir -p -- "$1" && cd -- "$1"
}

# Let local integrations and overrides run after shared plugins and aliases.
if (( $+functions[zshrc_local_after_init] )); then
  zshrc_local_after_init
fi
