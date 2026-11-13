# Detect the app hosting this shell (macOS + Linux) as $DOTFILES_TERMINAL_APP;
# empty for plain terminals.
typeset -ga dotfiles_plain_terminals=(
  ghostty kitty alacritty foot wezterm-gui terminal iterm2 konsole 'gnome-terminal*' xterm
)
typeset -gA dotfiles_app_aliases=(herdr-core herdr-app)

() {
  local app pid=$PPID name pattern
  if [[ -n $ORCA_PANE_KEY ]]; then app=orca
  elif [[ $HERDR_ENV == 1 ]]; then app=herdr
  elif [[ -v DOTFILES_TERMINAL_APP ]]; then return
  else
    while (( pid > 1 )); do
      name=${${(L)"$(ps -o comm= -p $pid)"}:t}
      case $name in
        (-*|zsh|bash|sh|dash|fish|ksh|login|su|sudo|sshd*) ;;
        (*) app=${name// /-}; break ;;
      esac
      pid=$(ps -o ppid= -p $pid)
    done
  fi
  app=${dotfiles_app_aliases[$app]:-$app}
  for pattern in $dotfiles_plain_terminals; do
    [[ $app == ${~pattern} ]] && app=''
  done
  export DOTFILES_TERMINAL_APP=$app
}
