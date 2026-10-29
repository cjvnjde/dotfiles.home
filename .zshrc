# Resolve the symlink before loading companion and machine-specific files.
typeset -g _dotfiles_shell_dir="${${(%):-%x}:A:h}"

# Source local environment at top level so PATH and typeset settings persist.
if [[ -f "$_dotfiles_shell_dir/.zshrc.local" ]]; then
  source "$_dotfiles_shell_dir/.zshrc.local"
fi

# Zsh reads history when .zshrc returns, before deferred integrations run.
source "$_dotfiles_shell_dir/zsh/history.zsh"

if [[ ${DOTFILES_FAST_PROMPT:-0} == 1 && ${DOTFILES_DEFER_INIT:-1} != 0 &&
      -f "$_dotfiles_shell_dir/.zshrc.local" && -o interactive && -o zle && -t 0 && -t 1 ]]; then
  # Built-in prompt expansion needs no subprocesses. Starship replaces this
  # once integrations are ready; input remains in ZLE's buffer during startup.
  typeset -g _dotfiles_fast_start=1
  PROMPT=$'╭─%B%F{green}%n@%m %F{blue}%~%f%b\n╰─%B%(!.#.$)%b '
  RPROMPT=''
  bindkey -e
  source "$_dotfiles_shell_dir/zsh/deferred.zsh"
else
  source "$_dotfiles_shell_dir/zsh/integrations.zsh"
fi
