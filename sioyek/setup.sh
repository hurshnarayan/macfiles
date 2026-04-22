#!/usr/bin/env bash
# Symlinks sioyek's user config from ~/.config/sioyek/ into the macOS location
# sioyek actually reads from (~/Library/Application Support/Sioyek/).
# Idempotent — safe to re-run. See README.md for details.

set -euo pipefail

SRC_DIR="$HOME/.config/sioyek"
DST_DIR="$HOME/Library/Application Support/Sioyek"

if [[ "$(uname)" != "Darwin" ]]; then
  echo "This setup script is macOS-only (sioyek on Linux already reads ~/.config/sioyek/)." >&2
  exit 0
fi

mkdir -p "$DST_DIR"

for f in keys_user.config prefs_user.config; do
  src="$SRC_DIR/$f"
  dst="$DST_DIR/$f"

  if [[ ! -f "$src" ]]; then
    echo "skip: $src not found" >&2
    continue
  fi

  # If a real file already exists at the destination, back it up before symlinking.
  if [[ -e "$dst" && ! -L "$dst" ]]; then
    backup="$dst.backup.$(date +%Y%m%d-%H%M%S)"
    mv "$dst" "$backup"
    echo "backed up existing $f -> $backup"
  fi

  ln -sf "$src" "$dst"
  echo "linked: $dst -> $src"
done

echo "done. open sioyek and press 'r' to reload config (or restart it)."
