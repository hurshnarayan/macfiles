# scripts

Helper scripts used by tmux binds and fish aliases. This folder is added to `PATH` by fish (`config.fish` has `fish_add_path -p $HOME/.config/scripts`), so all scripts are callable by name from any shell.

## Files

### tmux-sessionizer

Primeagen-style project picker. The core of the `Ctrl+F` / `prefix+f` workflow.

**What it does:**
- With no arguments: opens an `fzf` picker over dirs one level deep under `~/code`, `~/personal`, and `~`. Pick a project, it creates or attaches to a tmux session rooted there.
- With one argument (a directory path): skips the picker and creates-or-attaches to a session at that dir. This is how the directory-jump binds work.
- Session name is the dir's basename with `.` replaced by `_` (tmux uses `.` as a target separator, so `.config` becomes `_config`).
- Handles all four cases correctly:
  - Outside tmux, no server running: `tmux new-session` (foregrounds you).
  - Outside tmux, server running elsewhere: `tmux attach`.
  - Inside tmux, session exists: `tmux switch-client`.
  - Inside tmux, session missing: `new-session -d` then `switch-client`.

**Wired up by:**
- `fish/functions/fish_user_key_bindings.fish` binds `Ctrl+F` to run this script. Works at any fish prompt.
- `tmux/tmux.conf` binds `prefix + f` (`Ctrl+A f`) to run this script inside a new tmux window.
- Commented directory-jump templates in `tmux.conf` call this script with a directory argument (`tmux-sessionizer ~/code`).

### open-pdf.sh

Sylvan-style PDF picker. Fuzzy-pick a document, open in sioyek.

**What it does:**
- Uses `fd` to list `.pdf`, `.epub`, and `.djvu` files under `~/Documents` up to 4 levels deep.
- Strips the `$HOME/` prefix so paths display cleaner in the picker.
- Pipes through `fzf` for selection.
- Launches `sioyek` in a detached tmux window (`new-window -d`) so your current window keeps focus while sioyek's GUI opens.

**Wired up by:**
- `tmux/tmux.conf` binds `prefix + p` to run this script in a new tmux window.

**Dependencies:** `fd`, `fzf`, `sioyek` (all via `brew install`).

**Add more folders:** edit the `DIRS=(...)` array at the top of the script (e.g. add `"$HOME/Downloads"`).

### fzf-git.sh

Junegunn's `fzf-git` helpers (from `github.com/junegunn/fzf-git.sh`). Provides widgets for fuzzy-picking git branches, commits, remotes, tags, etc.

**Not currently wired up in fish.** This file is sourced from the old `~/.zshrc`. If you want it in fish, you would need to translate the bindings. Left here as a reference.

### fzf_listoldfiles.sh

Recent-files picker. Launches nvim with the selection.

**What it does:**
- Runs `nvim --headless` to extract `vim.v.oldfiles` (nvim's recent-files list).
- Filters to files that still exist on disk.
- Shows them in `fzf` with a `bat` preview pane.
- Opens the selected file in nvim.

**Wired up by:**
- `fish/config.fish` aliases it as `nlof`.

Type `nlof` at any fish prompt to launch it.

### zoxide_openfiles_nvim.sh

Fuzzy-pick any file and open in nvim, optionally filtered by zoxide's frequent-dirs list.

**What it does:**
- No argument: runs `fd` over the current dir, pipes into `fzf` with a `bat` preview, opens the pick in nvim.
- With a query argument: runs `fd <query>` against **every dir zoxide has tracked** (so you can find files across all your frecent projects). Auto-opens if only one match; otherwise fzf.

**Wired up by:**
- `fish/config.fish` aliases it as `nzo`.

Examples:
- `nzo` — search files in current directory tree.
- `nzo config.fish` — search for `config.fish` across all zoxide-tracked dirs.

## Adding a new script

1. Drop the script in this folder.
2. `chmod +x` it.
3. Wire it up either by binding a tmux key (in `tmux/tmux.conf`) or adding a fish alias/binding (in `fish/config.fish` or `fish/functions/fish_user_key_bindings.fish`).
4. Since this folder is already on `PATH`, you can call it by name (no full path needed) from any shell.
