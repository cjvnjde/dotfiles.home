## Custom Oh My Zsh Plugins

The `.zshrc` requires the following custom plugins to be cloned into the Oh My Zsh custom plugins directory:

```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/romkatv/zsh-defer ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-defer
```

## Local Overrides

The `.zshrc` file will automatically source `$HOME/.zshrc_local` if it exists. This is the ideal place for private aliases, environment variables, or sourcing scripts that are only present on one machine.

```bash
# ~/.zshrc_local

alias work-project="cd ~/projects/work/my-secret-project"
export GITHUB_TOKEN="your_token_here"
```
