## Custom Oh My Zsh Plugins

The `.zshrc` requires the following custom plugins to be cloned into the Oh My Zsh custom plugins directory:

```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

## Shell Appearance

The shell follows the terminal's light/dark palette without a background watcher:

- The Bira prompt layout is unchanged. Git/Mercurial and quoted-string accents
  use ANSI blue instead of yellow so they remain readable on Catppuccin Latte.
- `fzf` uses the terminal's default foreground/background and ANSI accents
  rather than a fixed Mocha palette.
- `bat` detects the terminal background when displaying directly, selecting
  Catppuccin Latte or Mocha through `BAT_THEME_LIGHT` and `BAT_THEME_DARK`.
- `ff` reads `org.gnome.desktop.interface color-scheme` with `gsettings` when
  opened and passes an explicit mode to its `bat` preview. Preview output is
  piped through `fzf`, where terminal background detection is unreliable.
  Reopen `ff` after changing the desktop mode to refresh its preview colors.

Load these settings into an existing Zsh session once:

```zsh
source ~/.zshrc
```

## Local Overrides

The `.zshrc` file will automatically source `$HOME/.zshrc_local` if it exists. This is the ideal place for private aliases, environment variables, or sourcing scripts that are only present on one machine.

```bash
# ~/.zshrc_local

alias work-project="cd ~/projects/work/my-secret-project"
export GITHUB_TOKEN="your_token_here"
```
