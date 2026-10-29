# Run the optional local hook once, after the first prompt is visible. Finish
# before accepting input if the user submits a command before the idle callback.
# Keep this hook limited to non-interactive initialization (no password prompts).
autoload -Uz add-zle-hook-widget

_dotfiles_finish_init() {
  (( ${_dotfiles_init_pending:-0} )) || return 0
  _dotfiles_init_pending=0
  if (( ${+_dotfiles_init_fd} )); then
    zle -F "$_dotfiles_init_fd"
    exec {_dotfiles_init_fd}<&-
    unset _dotfiles_init_fd
  fi
  add-zle-hook-widget -d line-finish _dotfiles_finish_init

  if (( ${_dotfiles_fast_start:-0} )); then
    local _dotfiles_key
    for _dotfiles_key in "${(@k)_dotfiles_startup_bindings}"; do
      bindkey -M emacs "$_dotfiles_key" "${_dotfiles_startup_bindings[$_dotfiles_key]}"
    done
    unset _dotfiles_startup_bindings
    source "$_dotfiles_shell_dir/zsh/integrations.zsh"
    unset _dotfiles_fast_start
  else
    zshrc_local_deferred_init
    # Atuin installs widgets, so load highlighting after it, as in eager startup.
    _dotfiles_load_plugin zsh-syntax-highlighting
    unfunction _dotfiles_load_plugin
  fi
  return 0
}

_dotfiles_init_key() {
  local _dotfiles_pressed=$KEYS
  _dotfiles_finish_init
  local -a _dotfiles_binding=( ${(z)"$(bindkey -M emacs "$_dotfiles_pressed")"} )
  zle "${_dotfiles_binding[2]}"
}

_dotfiles_init_idle() {
  # Let buffered input run first; line-finish covers an immediately pasted command.
  (( KEYS_QUEUED_COUNT || PENDING )) && return 0
  local _dotfiles_refresh_prompt=${_dotfiles_fast_start:-0}
  _dotfiles_finish_init
  # Refresh suggestions and the prompt after mise updates the environment.
  if (( _dotfiles_refresh_prompt && $+functions[prompt_starship_precmd] )); then
    true
    prompt_starship_precmd
  fi
  (( $+functions[_zsh_autosuggest_start] )) && _zsh_autosuggest_start
  zle reset-prompt
  zle -R
}

typeset -g _dotfiles_init_pending=1
if [[ ${DOTFILES_DEFER_INIT:-1} != 0 && -o interactive && -o zle && -t 0 && -t 1 ]]; then
  if (( ${_dotfiles_fast_start:-0} )); then
    # Tab and history keys must work even if pressed before the idle callback.
    typeset -gA _dotfiles_startup_bindings
    zle -N _dotfiles_init_key
    () {
      local key
      local -a binding
      for key in $'\t' $'\x12' $'\e[A' $'\eOA'; do
        binding=( ${(z)"$(bindkey -M emacs "$key")"} )
        _dotfiles_startup_bindings[$key]=${binding[2]}
        bindkey -M emacs "$key" _dotfiles_init_key
      done
    }
  fi
  zle -N _dotfiles_init_idle
  add-zle-hook-widget line-finish _dotfiles_finish_init
  # /dev/null is immediately readable; ZLE services it when waiting for input.
  exec {_dotfiles_init_fd}</dev/null
  zle -F -w "$_dotfiles_init_fd" _dotfiles_init_idle
else
  # Shells without a line editor (including zsh -ic) still need their tools.
  _dotfiles_finish_init
fi
