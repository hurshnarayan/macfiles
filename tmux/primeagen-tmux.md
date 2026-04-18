# Primeagen's fzf + tmux Workflow

A guide to the project-switching workflow Primeagen uses, how it's wired together, and how the same setup is configured on this machine.

---

## 1. The Big Idea

Pressing **one key** (`Ctrl+F`) anywhere should:

1. Pop open a fuzzy picker (fzf) of every project you care about.
2. Let you type a few letters to filter.
3. Drop you into a **tmux session** scoped to that project.
4. The next time you pick the same project, you land **back in the exact session** you left — same nvim buffers, same splits, same shell history.

Each project = a long-lived tmux workspace you bounce between with one keystroke. No mental overhead about "where was I working", no re-opening editors, no `cd`-ing around.

---

## 2. The Script: `tmux-sessionizer`

This is the engine of the whole workflow.

**Location on this machine:** `~/.config/scripts/tmux-sessionizer`
**Prime's location:** `~/.local/bin/tmux-sessionizer`

```bash
#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find ~/code ~/personal ~ -mindepth 1 -maxdepth 1 -type d | fzf)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s "$selected_name" -c "$selected"
    exit 0
fi

if ! tmux has-session -t="$selected_name" 2> /dev/null; then
    tmux new-session -ds "$selected_name" -c "$selected"
fi

tmux switch-client -t "$selected_name"
```

### What each block does

| Block | Purpose |
|---|---|
| `if [[ $# -eq 1 ]]` | If a path was passed as an argument, **skip fzf** and use it directly. This is what powers the project-shortcut bindings (e.g. `prefix + G` straight to one project). |
| `find ... \| fzf` | Otherwise, list folders and let the user fuzzy-pick. |
| `basename ... \| tr . _` | Turn `my.project` into `my_project` — tmux session names can't contain dots. |
| `[[ -z $TMUX ]] && [[ -z $tmux_running ]]` | "No tmux running anywhere": create + attach a fresh session. |
| `! tmux has-session ...` | "Tmux running but session for this project doesn't exist yet": create it detached. |
| `tmux switch-client` | Switch the current tmux client to that session. |

---

## 3. Why Those Specific Search Paths?

The `find` command in the script:

```bash
find ~/code ~/personal ~ -mindepth 1 -maxdepth 1 -type d
```

The flags `-mindepth 1 -maxdepth 1` mean **"go exactly one level deep — don't recurse."**

So each path you list contributes one level of children to the picker:

- `~/code` → every folder directly inside `~/code` (your projects there)
- `~/personal` → every folder directly inside `~/personal`
- `~/` → every folder directly inside home (`~/code`, `~/personal`, `~/Downloads`, etc.)

### Why not just `find ~/`?

Two failure modes if you tried to be clever:

1. **`find ~/` with no depth limit** → tens of thousands of results (every `node_modules`, every `.git`, every nested folder). fzf becomes unusable.
2. **`find ~/ -maxdepth 1`** → only top-level home folders (`work`, `personal`). You'd never see the actual projects nested inside.

### The pattern

Hand-pick the **parent directories whose immediate children are projects**. Each listed path says: *"treat the folders directly inside here as picker entries."*

Result: a clean, flat list of exactly the project roots you care about — fast to generate, no junk, no recursion.

---

## 4. The Two Keybinding Layers

Prime defined the binding **in two places** so it works everywhere:

### Layer A: Shell-level binding (`Ctrl+F`)

Works at a bare shell prompt — **whether tmux is running or not**.

**Prime (zsh):** `~/.zsh_profile`
```zsh
bindkey -s ^f "tmux-sessionizer\n"
```

**This machine (fish):** `~/.config/fish/functions/fish_user_key_bindings.fish`
```fish
bind -M insert \cf 'commandline "tmux-sessionizer"; commandline -f execute'
bind \cf 'commandline "tmux-sessionizer"; commandline -f execute'
```

(Two binds because fish is in vi mode — one for insert mode, one for default/normal mode.)

### Layer B: Tmux-level binding (`prefix + f`)

Works **only while inside tmux** (because `bind-key` is a tmux command).

**Prime:** `~/.tmux.conf`
```
bind-key -r f run-shell "tmux neww ~/.local/bin/tmux-sessionizer"
```

**This machine:** `~/.config/tmux/tmux.conf`
```
bind-key -r f run-shell "tmux neww ~/.config/scripts/tmux-sessionizer"
```

Prefix on this machine: **`Ctrl+A`** (Prime's same choice — overrides tmux default `Ctrl+B`).

### Why both layers?

The shell binding alone would technically be enough — even inside tmux you're still at a shell prompt. But:

- **Shell-level `Ctrl+F`** runs the picker in your current pane, replacing the prompt momentarily.
- **Tmux-level `prefix + f`** uses `tmux neww` to spawn the picker in a *new tmux window* and closes it when done. Your existing window stays untouched while picking.

Muscle memory: `Ctrl+F` from anywhere; `prefix + f` when your hand is already on the prefix.

---

## 5. The State Machine

The script handles three situations:

| Situation | What happens |
|---|---|
| **No tmux running** | Creates a session and **attaches** you to it. Fresh shell prompt sitting in the project's directory. |
| **Tmux running, session for this project doesn't exist yet** | Creates the session **detached**, then `switch-client`s you into it. |
| **Tmux running, session for this project already exists** | Just `switch-client`s — drops you back into your existing workspace, exactly as you left it. |

### "Is the session empty when first created?"

Yes — a brand-new session is just:
- 1 window
- 1 pane
- A shell prompt in that project's directory

That's it. No editor, no splits, nothing running. **Empty but ready.**

The magic kicks in **the second time** you pick that project. The session already exists, so `switch-client` just drops you back — your nvim, your splits, your shell history, all preserved. That's the whole point of the workflow: each project is a persistent workspace.

---

## 6. Project-Specific Shortcut Keys

Prime had **one-key bindings to his most-used projects**, bypassing the fzf picker:

```
bind-key -r G run-shell "~/.local/bin/tmux-sessionizer ~/work/nrdp"
bind-key -r C run-shell "~/.local/bin/tmux-sessionizer ~/work/tvui"
bind-key -r R run-shell "~/.local/bin/tmux-sessionizer ~/work/milo"
bind-key -r H run-shell "~/.local/bin/tmux-sessionizer ~/personal/vim-with-me"
bind-key -r T run-shell "~/.local/bin/tmux-sessionizer ~/personal/refactoring.nvim"
bind-key -r N run-shell "~/.local/bin/tmux-sessionizer ~/personal/harpoon"
bind-key -r S run-shell "~/.local/bin/tmux-sessionizer ~/personal/developer-productivity"
```

### How it works

The script's first check:
```bash
if [[ $# -eq 1 ]]; then
    selected=$1     # ← skip fzf, use the arg directly
fi
```

So passing a path as an argument **bypasses the picker** and goes straight to that project's session.

### Why bother with hardcoded shortcuts?

Two-tier system:

- **`prefix + f`** → fuzzy picker for *anything* (the general case).
- **`prefix + G/C/R/H/T/N/S`** → muscle memory for the **5–8 projects he opens 50 times a day**. No typing, no fuzzy match, just one key → instant session.

Think of it like: fzf is the address bar; the letters are the bookmark bar.

These have been removed from this machine's tmux.conf because the paths (`~/work/nrdp`, etc.) were Prime's repos. They can be re-added pointing at your projects when you identify which projects you open most.

---

## 7. Other fzf Bindings Prime Got "for Free"

Prime sourced fzf's stock keybinding files in his zsh:

```zsh
source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh
```

These give you fzf's built-in shell bindings:

| Key | What it does |
|---|---|
| `Ctrl+T` | Fuzzy-pick a file/dir and paste its path into the command line |
| `Ctrl+R` | Fuzzy-search shell history |
| `Alt+C` | Fuzzy-pick a directory and `cd` into it |

The fish equivalent on this machine is `fzf --fish | source` in `~/.config/fish/config.fish`, which provides the same `Ctrl+T` / `Ctrl+R` / `Alt+C` bindings.

(Note: the **only** fzf-driven binding Prime defines himself is `Ctrl+F` → `tmux-sessionizer`. The other three come from fzf's own scripts.)

---

## 8. File Map: Prime vs This Machine

| Component | Prime | This Machine |
|---|---|---|
| Sessionizer script | `~/.local/bin/tmux-sessionizer` | `~/.config/scripts/tmux-sessionizer` |
| Shell keybind file | `~/.zsh_profile` | `~/.config/fish/functions/fish_user_key_bindings.fish` |
| Shell PATH addition | `addToPathFront $HOME/.local/scripts` (in `.zsh_profile`) | `fish_add_path -p $HOME/.config/scripts` (in `~/.config/fish/config.fish`) |
| Tmux config | `~/.tmux.conf` | `~/.config/tmux/tmux.conf` |
| Tmux prefix | `Ctrl+A` | `Ctrl+A` |
| Project search paths | `~/work/builds`, `~/projects`, `~`, `~/work`, `~/personal`, `~/personal/yt` | `~/code`, `~/personal`, `~` |

---

## 9. Cheat Sheet

| Key | Where | What it does |
|---|---|---|
| `Ctrl+F` | Any shell prompt (inside or outside tmux) | Open fzf picker → pick project → enter tmux session |
| `prefix + f` (i.e. `Ctrl+A f`) | Inside tmux only | Same picker, opened in a new tmux window |
| `Ctrl+T` | Any shell prompt | Fzf file picker, pastes path into command line |
| `Ctrl+R` | Any shell prompt | Fzf history search |
| `Alt+C` | Any shell prompt | Fzf directory picker, `cd` into it |
| `prefix + r` | Inside tmux | Reload tmux.conf |
| `prefix + h/j/k/l` | Inside tmux | Vim-like pane navigation |

---

## 10. Mental Model: Why This Workflow Wins

Without this workflow, switching projects looks like:
1. `cd ~/code/some-project`
2. Open tmux session manually (or not — work in a single shell).
3. Open editor.
4. Maybe split a pane for tests.
5. Realize you also need to do something in another project — repeat all of the above.
6. Lose track of which terminal is which project.

With this workflow:
1. `Ctrl+F`, type a few letters, Enter.
2. You're in. Your editor and splits from last time are still there.

The script removes the **friction of returning** to a project. That's why the persistent-sessions part matters — you stop worrying about "saving state" because tmux holds it for you.
