#!/usr/bin/env bash
set -euo pipefail

# Directories to scan for documents. Add more as you like.
DIRS=(
    "$HOME/Documents"
)

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(fd . "${DIRS[@]}" \
        --max-depth=4 \
        --extension=pdf --extension=epub --extension=djvu \
        --full-path --base-directory "$HOME" \
        | sed "s|^$HOME/||" \
        | sort -uf \
        | fzf)

    [[ $selected ]] && selected="$HOME/$selected"
fi

[[ -n "$selected" ]] || exit 0

if [[ -n "${TMUX:-}" ]]; then
    tmux new-window -d "exec sioyek $(printf '%q' "$selected")"
else
    exec sioyek "$selected"
fi
