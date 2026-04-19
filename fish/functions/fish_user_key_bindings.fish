function fish_user_key_bindings
    # peco
    bind \cr peco_select_history # Bind for peco select history to Ctrl+R

    # tmux-sessionizer (Prime-style): Ctrl+F → fzf project picker → tmux session
    bind -M insert \cf 'commandline "tmux-sessionizer"; commandline -f execute'
    bind \cf 'commandline "tmux-sessionizer"; commandline -f execute'

    # vim-like
    bind \cl forward-char

    # prevent iterm2 from closing when typing Ctrl-D (EOF)
    bind \cd delete-or-exit
end
