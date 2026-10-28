# Resolve the symlink before loading companion and machine-specific files.
typeset -g _dotfiles_shell_dir="${${(%):-%x}:A:h}"

# Local paths and tool setup must be available to shared integrations.
if [[ -f "$_dotfiles_shell_dir/.zshrc.local" ]]; then
  source "$_dotfiles_shell_dir/.zshrc.local"
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

source "$_dotfiles_shell_dir/zsh/interactive.zsh"
source "$_dotfiles_shell_dir/zsh/aliases.zsh"

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

if command -v starship >/dev/null 2>&1; then
  export STARSHIP_CONFIG="${STARSHIP_CONFIG:-$_dotfiles_shell_dir/starship.toml}"
  eval "$(starship init zsh)"
else
  PROMPT=$'╭─%B%F{green}%n@%m %F{blue}%~%f%b\n╰─%B%(!.#.$)%b '
fi

# Load suggestions before local widgets (Atuin), and highlighting last.
_dotfiles_load_plugin zsh-autosuggestions

# Preserve late overrides on machines still using the legacy local file.
if [[ ! -f "$_dotfiles_shell_dir/.zshrc.local" && -f "$HOME/.zshrc_local" ]]; then
  source "$HOME/.zshrc_local"
fi

# Let local integrations and overrides run after shared aliases and prompt setup.
if (( $+functions[zshrc_local_after_init] )); then
  zshrc_local_after_init
fi

_dotfiles_load_plugin zsh-syntax-highlighting
unfunction _dotfiles_load_plugin
unset _dotfiles_shell_dir
