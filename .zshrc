export XDG_CONFIG_HOME="$HOME/.config"
export ZSH="$HOME/.oh-my-zsh"

export BAT_THEME="auto"
export BAT_THEME_LIGHT="Catppuccin Latte"
export BAT_THEME_DARK="Catppuccin Mocha"

export FZF_DEFAULT_OPTS='
--height 40%
--layout=reverse
--border
--color=base16,bg:-1,fg:-1,bg+:-1,fg+:-1,hl:4,hl+:4,info:4,prompt:4,pointer:4,marker:4,spinner:4,header:4,border:8
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

# Use terminal palette accents that remain readable in both Latte and Mocha.
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[blue]%}‹"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}●%{$fg[blue]%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%}"
ZSH_THEME_HG_PROMPT_PREFIX="$ZSH_THEME_GIT_PROMPT_PREFIX"
ZSH_THEME_HG_PROMPT_DIRTY="$ZSH_THEME_GIT_PROMPT_DIRTY"
ZSH_THEME_HG_PROMPT_CLEAN="$ZSH_THEME_GIT_PROMPT_CLEAN"

for highlight_style in reserved-word single-quoted-argument double-quoted-argument dollar-quoted-argument redirection; do
  ZSH_HIGHLIGHT_STYLES[$highlight_style]='fg=blue'
done
unset highlight_style

if (( ${+aliases[ff]} )); then
  unalias ff
fi

ff() {
  local color_scheme
  color_scheme="$(gsettings get org.gnome.desktop.interface color-scheme)" || return

  # Preview output is piped through fzf, so bat cannot detect its background.
  local theme=light
  [[ "$color_scheme" == "'prefer-dark'" ]] && theme=dark
  BAT_THEME="$theme" fzf --preview 'bat --style=numbers --color=always {}' "$@"
}

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
