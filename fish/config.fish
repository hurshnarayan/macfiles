set fish_greeting

set -gx TERM xterm-256color

alias pip "python3 -m pip"

fzf --fish | source

# navigation
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# aliases confirm before overwriting something
alias cp="cp -i"
alias mv='mv -i'
alias rm='rm -i'

alias python="python3"

alias ls="eza --no-filesize --long --color=always --icons=always --no-user"
alias cat="bat"
alias g="git"
alias ga="git add ."
alias gs="git status -s"
alias gc='git commit -m'
alias glog='git log --oneline --graph --all'
alias gh-create='gh repo create --private --source=. --remote=origin && git push -u --all && gh browse'

command -qv nvim && alias vim nvim

set -gx EDITOR nvim

fish_add_path -g ~/bin
fish_add_path -g ~/.local/bin
fish_add_path -g $HOME/go/bin

# Go
set -g GOPATH $HOME/go

# ----------------------------------------
# Aliases
# ----------------------------------------

# fzf – called from ~/scripts/
alias nlof="~/.config/scripts/fzf_listoldfiles.sh"

# man pages via fzf
# fish does NOT have compgen, use `complete -C`
alias fman="complete -C '' | fzf | xargs man"

# zoxide helper (called from ~/scripts/)
alias nzo="~/.config/scripts/zoxide_openfiles_nvim.sh"

# ----------------------------------------
# Environment variables
# ----------------------------------------

set -x TEALDEER_CONFIG_DIR "$HOME/.config/tealdeer/"

fish_add_path -p $HOME/.config/scripts

# ----------------------------------------
# FZF configuration
# ----------------------------------------

set -x FZF_DEFAULT_COMMAND "fd --hidden --strip-cwd-prefix --exclude .git --exclude node_modules --exclude .gradle --exclude .local --exclude .pub-cache --exclude .cache --exclude .vscode --exclude .bundle --exclude .nvm --exclude .rbenv --exclude .cargo --exclude .npm --exclude Library --exclude 'go/pkg' --exclude vendor --exclude .venv --exclude __pycache__ --exclude .next --exclude dist --exclude build --exclude target --exclude .DS_Store"
set -x FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -x FZF_ALT_C_COMMAND "fd --type=d --hidden --strip-cwd-prefix --exclude .git --exclude node_modules --exclude .gradle --exclude .local --exclude .pub-cache --exclude .cache --exclude .vscode --exclude .bundle --exclude .nvm --exclude .rbenv --exclude .cargo --exclude .npm --exclude Library --exclude 'go/pkg' --exclude vendor --exclude .venv --exclude __pycache__ --exclude .next --exclude dist --exclude build --exclude target"

# primeagen-style: no FZF_DEFAULT_OPTS — bare `fzf` (e.g. tmux-sessionizer) uses
# fzf defaults (fullscreen, no border). Ctrl+T / Alt+C keep the nice popup look
# below via their own per-widget opts.

# Previews + popup-style window for Ctrl+T / Alt+C
set -x FZF_CTRL_T_OPTS "--height 50% --layout=default --border --color=hl:#2dd4bf --preview 'bat --color=always -n --line-range :500 {}'"
set -x FZF_ALT_C_OPTS "--height 50% --layout=default --border --color=hl:#2dd4bf --preview 'eza --icons=always --tree --color=always {} | head -200'"

# tmux
set -x FZF_TMUX_OPTS "-p90%,70%"

# ----------------------------------------
# Key bindings (fish style)
# ----------------------------------------

# vi mode (equivalent to `bindkey -v`)
fish_vi_key_bindings

# Autosuggestion accept (Ctrl+E)
bind -M insert \ce accept-autosuggestion

# History navigation (vi insert mode)
bind -M insert \cp up-or-search
bind -M insert \cn down-or-search

# Unbind Ctrl+G
bind --erase \cg

# ----------------------------------------
# Initializers
# ----------------------------------------

# zoxide
zoxide init fish | source

# fzf (THIS is what adds Ctrl-T / Alt-C)
fzf --fish | source

switch (uname)
    case Darwin
        source (dirname (status --current-filename))/config-osx.fish
    case Linux
        source (dirname (status --current-filename))/config-linux.fish
    case '*'
        source (dirname (status --current-filename))/config-windows.fish
end

set LOCAL_CONFIG (dirname (status --current-filename))/config-local.fish
if test -f $LOCAL_CONFIG
    source $LOCAL_CONFIG
end

mise activate fish | source
