## Zsh configuration

`~/.zshrc` is a symlink to this repository's `.zshrc`. The shell uses plain Zsh, Starship, zsh-autosuggestions, and zsh-syntax-highlighting. Oh My Zsh is no longer loaded or required.

### Install

macOS (Homebrew):

```bash
brew install starship zsh-autosuggestions zsh-syntax-highlighting
```

For Docker completion, use your Docker installation's completion directory in `fpath`, or generate the completion once:

```zsh
mkdir -p ~/.local/share/zsh/completions
docker completion zsh > ~/.local/share/zsh/completions/_docker
```

Arch Linux:

```bash
sudo pacman -S zsh starship zsh-autosuggestions zsh-syntax-highlighting
```

Alternatively, clone the typing plugins into `~/.local/share/zsh/plugins`:

```bash
mkdir -p ~/.local/share/zsh/plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.local/share/zsh/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.local/share/zsh/plugins/zsh-syntax-highlighting
```

Enable the existing `zshrc` module with `bash home/setup/zshrc.sh enable`. Its symlink also makes the companion `zsh/` files and `starship.toml` available; no separate prompt installation or config symlink is necessary.

### Shared settings

- `starship.toml` recreates bira's two-line prompt: green user/host, blue full directory, yellow Git branch, red dirty indicators, virtual environment, and a right-side failure code. Only the listed modules run. Set `STARSHIP_CONFIG` locally to use a different config.
- `zsh/interactive.zsh` provides persistent shared history in the existing `~/.zsh_history`, completion with a dump in the XDG cache directory, Emacs keybindings and arrow history search. Right arrow accepts a ghost suggestion; Ctrl-R and arrow bindings can be overridden by Atuin.
- `zsh/aliases.zsh` loads the complete former Git and Docker shortcut sets, including `gpsup`, `gpsupf`, `ggpush`, `ggpull`, branch helpers, and completion mappings. It also restores core directory/history/grep/sudo shortcuts and the colored-man-pages helpers (`man`, `dman`, `debman`, `colored`). The MIT-licensed definitions live in `zsh/vendor/oh-my-zsh` with source attribution. The Oh My Zsh framework, updater, and old prompt are not loaded; an installed Oh My Zsh checkout is unnecessary. Add personal shortcuts in `zsh/aliases.zsh` or locally.
- Existing fzf, bat, eza, fd, and zoxide settings remain in `.zshrc`.

Typing plugins are loaded directly from Homebrew, standard Linux package locations, or `~/.local/share/zsh/plugins`. For other installation layouts, define `ZSH_PLUGIN_DIRS=(/path/to/plugin-parent)` in `.zshrc.local`. Each parent should contain `zsh-autosuggestions/zsh-autosuggestions.zsh` and/or `zsh-syntax-highlighting/zsh-syntax-highlighting.zsh`. Highlighting loads last, after local widget integrations.

### Machine-specific settings

`home/.zshrc.local` lives beside the shared `.zshrc` in this submodule and is gitignored. Copy `.zshrc.local.example` to `.zshrc.local`; it must not be committed. The symlinked shared file resolves its repository path before loading it. Existing `~/.zshrc_local` files remain a fallback until the new local file exists. Put machine-specific PATH entries, SDK paths, package-manager/runtime activation (Homebrew, mise), private environment variables, and account-specific checks here. The old `export ZSH=...` setting can be removed; it is unused.

The shared file loads `.zshrc.local` first, so its paths and environment are available before completion and shared integrations initialize. It calls an optional `zshrc_local_after_init` function after prompt setup and autosuggestions. Define that function for local alias overrides or integrations such as Atuin. Syntax highlighting loads after the hook.

Do not add machine-specific absolute installation paths or pinned mise version directories to the shared `.zshrc`.

On each new machine, create `home/.zshrc.local` with its actual installation locations. For example, on an Apple Silicon Mac:

```zsh
# home/.zshrc.local — customize for this machine
export XDG_CONFIG_HOME="$HOME/.config"

typeset -U path PATH
path=(/opt/homebrew/bin "$HOME/.local/bin" "$HOME/.local/scripts" $path)

# Keep activation after PATH edits. Let mise select tool versions dynamically.
eval "$(/opt/homebrew/bin/mise activate zsh)"

zshrc_local_after_init() {
  alias work-project='cd ~/projects/work'
  command -v atuin >/dev/null 2>&1 && eval "$(atuin init zsh)"
}
```

Apply shell changes by opening a new terminal or running `exec zsh -l`. Existing running shells keep their current configuration until restarted.

## Git configuration

The `git` module links `home/git/` to `~/.config/git/`. Shared settings live in
`git/config`, which includes `git/config.local` last. Copy
`git/config.local.example` to `git/config.local` for machine-specific identity,
signing, SSH, pager, and other settings. The local file is gitignored.

The old `home/.gitconfig_local` filename is replaced by `home/git/config.local`.
Setup removes only a `~/.gitconfig` symlink managed by this checkout. An unrelated
`~/.gitconfig` file is preserved; Git reads it after the XDG configuration, so it
can override your new settings.

For private edits, use `git config --file /path/to/home/git/config.local`.
To inspect effective global settings and include origins, use
`git config --global --includes --show-origin --list`.
