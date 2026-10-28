# Shell shortcuts from Oh My Zsh

Source: https://github.com/ohmyzsh/ohmyzsh
Revision: d2b7f557cceaddb16ba89bbf8200d8a8df35c4d8
License: MIT, included in LICENSE.txt.

These local snapshots preserve the former shell shortcuts without loading the framework, updater, theme, or prompt hooks. No installed Oh My Zsh checkout is needed.

- git.zsh: complete Git plugin, including aliases, functions, completion mappings, and Git-version conditionals.
- docker.zsh: complete alias section of the Docker plugin. Completion generation is omitted; standalone completion is already initialized by interactive.zsh.
- git-helpers.zsh: branch/user/repository helpers extracted from lib/git.zsh; prompt functions/hooks are omitted.
- functions.zsh: lib/functions.zsh with framework install/update management functions removed. Provides helpers used by shortcuts, including clipboard/open/take dependencies.
- directories.zsh, grep.zsh, history.zsh, clipboard.zsh, correction.zsh, theme-and-appearance.zsh: original core helpers and conditional aliases. Starship replaces the theme; theme-and-appearance only supplies the original color setup and ls alias.
- misc-aliases.zsh: sudo and optional ack aliases extracted from lib/misc.zsh, without widget changes.
- colored-man-pages.zsh and nroff: original colored-man-pages plugin and its Solaris helper.

Keep local additions in ../../aliases.zsh. When updating snapshots, compare regular/global/suffix alias maps and plugin functions against the source under the same shell environment, and retain this attribution.
