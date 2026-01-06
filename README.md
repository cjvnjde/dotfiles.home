The `.zshrc` file will automatically source `$HOME/.zshrc_local` if it exists. This is the ideal place for private aliases, environment variables, or sourcing scripts that are only present on one machine.

```bash
# ~/.zshrc_local

alias work-project="cd ~/projects/work/my-secret-project"
export GITHUB_TOKEN="your_token_here"
```
