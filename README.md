## Zsh configuration

`~/.zshrc` is a symlink to this repository's `.zshrc`. Keep it portable: shared functions, theme settings, plugin names, and integrations guarded with `command -v` belong here.

`~/.zshrc_local` is a separate file on each machine. It is not symlinked or installed by setup, and must not be committed. Put machine-specific settings here:

- PATH entries, installation locations, SDK paths, and project directories.
- Package-manager and runtime activation, including Homebrew and mise.
- Private environment variables, machine-specific aliases, and account-specific checks such as the Atuin key fingerprint.

Do not add absolute installation paths or pinned mise version directories to the shared `.zshrc`. Even paths based on `$HOME` belong in `.zshrc_local` when they configure local installations. References used to load the local file and Oh My Zsh are part of the shared loading logic.

The shared file loads `.zshrc_local` first, so its paths and environment are available before Oh My Zsh and shared tool integrations initialize. It calls an optional `zshrc_local_after_init` function at the end. Define that function in `.zshrc_local` for local alias overrides or integrations that must initialize after plugins, such as Atuin. The shared file still works when the local file or Oh My Zsh is absent.

On each new machine, create `~/.zshrc_local` with its actual installation locations. For example, on an Apple Silicon Mac:

```zsh
# ~/.zshrc_local — customize for this machine
export XDG_CONFIG_HOME="$HOME/.config"
export ZSH="$HOME/.oh-my-zsh"

typeset -U path PATH
path=(/opt/homebrew/bin "$HOME/.local/bin" "$HOME/.local/scripts" $path)

# Keep activation after PATH edits. Let mise select tool versions dynamically.
eval "$(/opt/homebrew/bin/mise activate zsh)"

zshrc_local_after_init() {
  alias work-project='cd ~/projects/work'
}
```

Apply shell changes by opening a new terminal or running `exec zsh -l`.

## Custom Oh My Zsh Plugins

When using Oh My Zsh, clone the following custom plugins into its custom plugins directory:

```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```
