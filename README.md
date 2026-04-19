# macfiles

My macOS dotfiles. Ghostty, tmux, fish, nvim, and whatever scripts keep them held together. Built from scratch, fueled by caffeine and an unreasonable number of hours tweaking colors nobody else will ever see. Works on my machine.

## Install

On a fresh macOS box:

```sh
# 1. Clone into ~/.config
git clone https://github.com/hurshnarayan/macfiles.git ~/.config

# 2. Install the tools everything depends on
brew install fish tmux ghostty neovim fzf fd bat eza \
             sioyek zoxide mise peco gh

# 3. Make fish your shell
echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/fish

# 4. Install fisher (fish plugin manager) and pull plugins
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
fisher update
```

Open a new terminal. nvim auto-installs its plugins on first launch via `vim.pack`. Done.
