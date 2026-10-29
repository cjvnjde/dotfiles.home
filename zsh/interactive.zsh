# Standalone Zsh behavior previously provided by Oh My Zsh.
autoload -Uz colors compinit
colors
zmodload zsh/complist
zmodload zsh/terminfo

setopt auto_cd auto_pushd pushd_ignore_dups pushd_minus
setopt auto_menu complete_in_word always_to_end interactive_comments
unsetopt menu_complete flowcontrol
WORDCHARS=''

# Package-manager completions, including Git and Docker. No brew subprocess.
fpath=("${XDG_DATA_HOME:-$HOME/.local/share}/zsh/completions" $fpath)
if (( $+commands[brew] )); then
  fpath=("${commands[brew]:h:h}/share/zsh/site-functions" $fpath)
fi
typeset -gU fpath
() {
  local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
  mkdir -p "$cache_dir"
  # Keep security checks and automatic completion invalidation. Deferred setup
  # cannot prompt for input, so ignore insecure paths in that mode.
  if (( ${_dotfiles_fast_start:-0} )); then
    compinit -i -d "$cache_dir/zcompdump-$ZSH_VERSION"
  else
    compinit -d "$cache_dir/zcompdump-$ZSH_VERSION"
  fi
  zstyle ':completion:*' use-cache yes
  zstyle ':completion:*' cache-path "$cache_dir"
}
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' special-dirs true
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

bindkey -e
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search edit-command-line
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
zle -N edit-command-line
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
[[ -n ${terminfo[kcuu1]} ]] && bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
[[ -n ${terminfo[kcud1]} ]] && bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
[[ -n ${terminfo[khome]} ]] && bindkey "${terminfo[khome]}" beginning-of-line
[[ -n ${terminfo[kend]} ]] && bindkey "${terminfo[kend]}" end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[Z' reverse-menu-complete
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^R' history-incremental-search-backward
bindkey '^X^E' edit-command-line
bindkey ' ' magic-space

_dotfiles_load_plugin() {
  local plugin="$1" root
  local -a roots
  # Override the search roots in .zshrc.local for other installation layouts.
  roots=("${ZSH_PLUGIN_DIRS[@]}" "${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins")
  (( $+commands[brew] )) && roots+=("${commands[brew]:h:h}/share")
  roots+=(/usr/share /usr/share/zsh/plugins /usr/local/share)
  for root in "${roots[@]}"; do
    if [[ -r "$root/$plugin/$plugin.zsh" ]]; then
      source "$root/$plugin/$plugin.zsh"
      return
    fi
  done
  print -u2 "zsh: missing $plugin; see home/README.md for installation"
}
