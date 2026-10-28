# Preserve the previous shortcuts using local MIT-licensed definitions.
# This loads no Oh My Zsh framework, updater, or theme.
() {
  local shortcut_dir="${${(%):-%x}:A:h}/vendor/oh-my-zsh"
  local file
  # Compatibility variable used only by the cached grep/color probes.
  typeset -g ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
  for file in functions clipboard directories grep history misc-aliases correction theme-and-appearance git-helpers git docker colored-man-pages; do
    source "$shortcut_dir/$file.zsh"
  done
}
