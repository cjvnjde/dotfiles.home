# Starship only renders this value. Git runs in a cancellable background worker,
# never in Starship's command_timeout window or in the foreground prompt hook.
(( $+functions[_dotfiles_git_status_stop] )) && _dotfiles_git_status_stop
typeset -gA _dotfiles_git_status_cache=()
typeset -g _dotfiles_git_status_fd='' _dotfiles_git_status_pid=''
typeset -g _dotfiles_git_status_dir='' _dotfiles_git_status_group=''
export DOTFILES_GIT_STATUS=''

_dotfiles_git_status_scan() {
  emulate -L zsh
  setopt pipefail
  local color
  color=$(command git --no-optional-locks -C "$1" status \
    --porcelain=v1 --untracked-files=normal --ignore-submodules=dirty 2>/dev/null |
    command awk '
    {
      status = substr($0, 1, 2)
      if (status ~ /^(DD|AU|UD|UA|DU|AA|UU)$/) conflict = 1
      else if (status == "??") untracked = 1
      else {
        if (status ~ /D/) deleted = 1
        if (substr(status, 2, 1) ~ /[AMTC]/) modified = 1
        if (status ~ /R/) renamed = 1
        if (substr(status, 1, 1) ~ /[AMTC]/) staged = 1
      }
    }
    END {
      print conflict ? 35 : deleted ? 31 : modified ? 33 : renamed ? 36 : staged ? 32 : untracked ? 34 : 0
    }') || color='-'
  print -r -- "$color"
}

_dotfiles_git_status_stop() {
  if [[ -n $_dotfiles_git_status_fd ]]; then
    zle -F "$_dotfiles_git_status_fd" 2>/dev/null
    exec {_dotfiles_git_status_fd}<&-
    _dotfiles_git_status_fd=''
  fi
  if [[ $_dotfiles_git_status_pid == <-> && $_dotfiles_git_status_pid -gt 1 ]]; then
    # With job control, the worker and its Git/awk children share a new group.
    if [[ $_dotfiles_git_status_group == on ]]; then
      kill -TERM -- "-$_dotfiles_git_status_pid" 2>/dev/null
    else
      kill -TERM -- "$_dotfiles_git_status_pid" 2>/dev/null
    fi
  fi
  _dotfiles_git_status_pid=''
  return 0
}

_dotfiles_git_status_request() {
  _dotfiles_git_status_stop
  export DOTFILES_GIT_STATUS=${_dotfiles_git_status_cache[$PWD]:-}
  _dotfiles_git_status_dir=$PWD
  _dotfiles_git_status_group=$options[monitor]
  exec {_dotfiles_git_status_fd}< <(
    # Only this immediate handshake is read synchronously, before any Git work.
    print -r -- "$sysparams[pid]"
    _dotfiles_git_status_scan "$PWD"
  )
  IFS= read -r -u "$_dotfiles_git_status_fd" _dotfiles_git_status_pid
  zle -F -w "$_dotfiles_git_status_fd" _dotfiles_git_status_ready
  return 0
}

_dotfiles_git_status_ready() {
  [[ $1 == "$_dotfiles_git_status_fd" ]] || return 0
  local color value=''
  IFS= read -r -u "$1" color
  zle -F "$1"
  exec {_dotfiles_git_status_fd}<&-
  _dotfiles_git_status_fd=''
  _dotfiles_git_status_pid=''
  case $color in
    31|32|33|34|35|36) value=$'\e[1;'"${color}"$'m●\e[0m ' ;;
  esac
  _dotfiles_git_status_cache[$_dotfiles_git_status_dir]=$value
  # A result from a different directory/worktree must never decorate this one.
  if [[ $PWD == "$_dotfiles_git_status_dir" && $DOTFILES_GIT_STATUS != "$value" ]]; then
    export DOTFILES_GIT_STATUS=$value
    # Preserve the edit buffer and Starship's captured command exit status.
    zle reset-prompt
    zle -R
  fi
  return 0
}

_dotfiles_git_status_chpwd() {
  _dotfiles_git_status_stop
  export DOTFILES_GIT_STATUS=''
}

if [[ -o interactive && -o zle && -t 0 && -t 1 ]]; then
  zmodload zsh/system
  autoload -Uz add-zsh-hook
  zle -N _dotfiles_git_status_ready
  add-zsh-hook precmd _dotfiles_git_status_request
  add-zsh-hook preexec _dotfiles_git_status_stop
  add-zsh-hook chpwd _dotfiles_git_status_chpwd
  add-zsh-hook zshexit _dotfiles_git_status_stop
  # Fast-prompt startup loads this file after the first precmd already ran.
  if zle; then
    _dotfiles_git_status_request
  fi
fi
