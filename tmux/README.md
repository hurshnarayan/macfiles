# tmux_harsh

My tmux config — modeled on ThePrimeagen's setup, adapted for macOS (`pbcopy` instead of `xclip`, `mouse on`).

**Leader key: `Ctrl+a`** (remapped from default `Ctrl+b`).

Throughout this doc, **`<L>`** means the leader — press `Ctrl+a`, release, then press the next key. Example: `<L> h` = press `Ctrl+a`, release, then press `h`.

---

## Table of contents

1. [Install / activate](#1-install--activate)
2. [Quick start: starting, listing, attaching, renaming sessions](#2-quick-start-starting-listing-attaching-renaming-sessions)
3. [Mental model](#3-mental-model)
4. [Keybindings from this config](#4-keybindings-from-this-config)
5. [Built-in tmux keybindings (not remapped)](#5-built-in-tmux-keybindings-not-remapped)
6. [Copy / paste](#6-copy--paste-vi-mode)
7. [Shell commands (`tmux …`)](#7-shell-commands-tmux-)
8. [Exit / kill patterns](#8-exit--kill-patterns)
9. [Companion files: `.tmux-cht-*`](#9-companion-files-tmux-cht-)
10. [Typical workflow](#10-typical-workflow)
11. [Running shell commands while editing in nvim](#11-running-shell-commands-while-editing-in-nvim)
12. [Troubleshooting](#12-troubleshooting)
13. [Sanity checks](#13-sanity-checks)

---

## 1. Install / activate

tmux looks for its config at `~/.tmux.conf` or `~/.config/tmux/tmux.conf`. Symlink one of those to this file:

```sh
# option A: XDG location (what `bind r` in the config reloads)
mkdir -p ~/.config/tmux
ln -sf ~/.config/tmux_harsh/tmux.conf ~/.config/tmux/tmux.conf

# option B: classic location
ln -sf ~/.config/tmux_harsh/tmux.conf ~/.tmux.conf
```

Reload inside tmux: `<L> r`.

### What's "XDG location"?

**XDG** = a freedesktop.org spec that says "stop dumping dotfiles in `~/`, put them in standard subdirectories." There are four main ones:

| Env var | Default on macOS/Linux | What goes there |
|---|---|---|
| `$XDG_CONFIG_HOME` | `~/.config` | **Config files** (nvim, tmux, fish, git, etc.) |
| `$XDG_DATA_HOME` | `~/.local/share` | App data (plugins, histories, databases) |
| `$XDG_CACHE_HOME` | `~/.cache` | Throwaway cache (safe to delete) |
| `$XDG_STATE_HOME` | `~/.local/state` | Logs, undo files, "last-used" state |

So **"XDG location for tmux"** = `$XDG_CONFIG_HOME/tmux/tmux.conf` = `~/.config/tmux/tmux.conf`.

Why option A over option B? Consistency. Everything else in your setup already lives under `~/.config/`:

```
~/.config/
├── nvim/           ← Neovim
├── tmux/           ← tmux (after symlinking)
├── fish/           ← fish shell
├── git/            ← git
├── alacritty/      ← Alacritty terminal
└── ghostty/        ← Ghostty terminal
```

Versus the legacy mess: `~/.vimrc`, `~/.tmux.conf`, `~/.bashrc`, `~/.gitconfig`, `~/.inputrc`… all scattered in `$HOME`.

You can check and override:

```sh
echo $XDG_CONFIG_HOME     # usually empty — that's fine, defaults to ~/.config
echo ~/.config            # resolves to /Users/harshnarayan/.config
```

Empty env var = defaults apply. Set it (e.g. in `~/.config/fish/config.fish`) only if you want configs somewhere unusual like a Dropbox folder. 99% of people leave it alone.

---

## 2. Quick start: starting, listing, attaching, renaming sessions

Everything below runs from a regular shell (outside tmux), except where noted.

### Start a new session

```sh
tmux                              # simplest — creates unnamed session (numbered 0, 1, 2…)
tmux new -s work                  # creates a NAMED session called "work" and attaches
tmux new -s work -d               # creates "work" DETACHED (runs in the background)
tmux new -s work -c ~/code/foo    # creates "work" starting in ~/code/foo
tmux new -As work                 # attach if "work" exists, else create it  (my favorite)
```

`-A` means "attach to existing, or create." Combined with `-s`, it's idempotent — run it every morning without thinking.

### See what's running

```sh
tmux ls                           # list all sessions. Empty = no tmux server running.
# example output:
#   work: 3 windows (created Fri Apr 18 08:12:04 2026)
#   0: 1 windows (created Fri Apr 18 09:30:11 2026) (attached)
```

The leading label is the session **name** (or a number for unnamed ones).

### Attach to a session

```sh
tmux a                            # attach to most recent session
tmux a -t work                    # attach to "work" specifically
tmux a -t 0                       # attach to unnamed session "0"
```

> Rule of thumb: **before running `tmux` to start fresh, run `tmux ls` first.** If something's already there, attach to it instead of creating another one.

### Rename an unnamed (or any) session

Three ways, pick whichever is in front of you.

**1. From inside tmux — single keystroke:**
```
<L> $          prompts in the status bar — type the new name, Enter
```

**2. From inside tmux — command prompt:**
```
<L> :                                open prompt
rename-session my-new-name           renames current session
```

**3. From the shell — target by old name or number:**
```sh
tmux rename-session -t 0 work        # rename unnamed session "0" to "work"
tmux rename-session -t old new       # rename "old" to "new"
```

Example flow — you started an unnamed session, decided it's the real thing:

```sh
tmux                 # starts session "0", attaches
# …you do some work…
<L> $                # prompt appears: "(rename-session) 0"
# type: project-x, hit Enter
tmux ls              # now shows: project-x: 1 windows (attached)
```

### Leave a session without killing it

```
<L> d                # detach — session keeps running, shell returns
tmux detach          # same thing from inside a pane's shell
```

Reattach anytime with `tmux a -t <name>`. Session survives terminal close, laptop sleep, SSH drops.

### Kill a session

```sh
tmux kill-session -t work         # kill "work" by name
tmux kill-server                  # nuke every session for this user
```
Or from inside tmux: `<L> :kill-session`. More ways in [§8 Exit / kill patterns](#8-exit--kill-patterns).

### 30-second muscle memory

```sh
tmux ls                           # what's running?
tmux new -As work -c ~/code/foo   # start or attach (idempotent)
# … work …
<L> d                             # detach when done
tmux a -t work                    # resume later
```

---

## 3. Mental model

```
server
└── session        (a workspace — e.g. "work", "dotfiles")
    └── window     (like a browser tab)
        └── pane   (a split inside the tab — each pane is one shell)
```

- Detach from a session with `<L> d` and it **keeps running in the background**. Reattach later with `tmux a -t work`. Close the terminal? Session's still alive. **This is the whole point of tmux.**
- One tmux **server** per user. All your sessions share it. `tmux kill-server` nukes everything.

---

## 4. Keybindings from this config

### Session / config
| Keys | Action |
|---|---|
| `<L> r` | Reload `~/.config/tmux/tmux.conf` |
| `<L> Ctrl+a` | Send a **literal** `Ctrl+a` keystroke to the program inside the pane (for nested tmux or readline's "beginning of line") |

> ⚠️ `<L> a` (lowercase, no Ctrl) is **not** bound. Only `<L> Ctrl+a` (both keys held) sends the literal prefix through.

### Pane navigation (vim-style)
| Keys | Action |
|---|---|
| `<L> h` | Move to pane on the **left** |
| `<L> j` | Move to pane **below** |
| `<L> k` | Move to pane **above** |
| `<L> l` | Move to pane on the **right** |
| `<L> ^` | Toggle to **last window** |

These are `-r` (**repeatable**) — after one `<L>`, you can keep tapping `h/j/k/l` (or `^`) without re-pressing the prefix.

### Workflow shortcuts
| Keys | Action |
|---|---|
| `<L> f` | Run `~/.local/bin/tmux-sessionizer` in a new window (fuzzy jump into projects) |
| `<L> i` | Run `tmux-cht.sh` — cheat.sh lookup |
| `<L> D` | Open `TODO.md` in nvim (local `TODO.md` if present, else `~/.dotfiles/personal/todo.md`) |

### Project jumps (tmux-sessionizer shortcuts)
Each opens the given path as a tmux session:

| Keys | Path |
|---|---|
| `<L> G` | `~/work/nrdp` |
| `<L> C` | `~/work/tvui` |
| `<L> R` | `~/work/milo` |
| `<L> H` | `~/personal/vim-with-me` |
| `<L> T` | `~/personal/refactoring.nvim` |
| `<L> N` | `~/personal/harpoon` |
| `<L> S` | `~/personal/developer-productivity` |

> These need the `tmux-sessionizer` script at `~/.local/bin/tmux-sessionizer`. Grab it from <https://github.com/ThePrimeagen/.dotfiles> (`bin/.local/bin/tmux-sessionizer`). `<L> i` similarly needs `tmux-cht.sh` on `$PATH`. Edit the paths in `tmux.conf` to match **your** projects — those defaults are Prime's.

---

## 5. Built-in tmux keybindings (not remapped)

### Windows (tabs)
| Keys | Action |
|---|---|
| `<L> c` | **Create** new window |
| `<L> ,` | **Rename** current window |
| `<L> n` | **Next** window |
| `<L> p` | **Previous** window |
| `<L> 1`..`9` | Jump to window N (just the number — **no extra `a`**) |
| `<L> w` | Session + window **tree picker** with live preview |
| `<L> &` | **Kill** current window (confirms `y/n`) |

**`<L> w` keys inside the picker:**
- `↑` / `↓` or `j` / `k` — move
- `Enter` — jump to selection
- `x` — kill selected window/session (confirms)
- `/` — filter by name
- `q` or `Esc` — cancel

Compare the listing shortcuts:

| Keys | Shows |
|---|---|
| `<L> s` | sessions only |
| `<L> w` | sessions → windows (tree, with preview pane) |
| `<L> q` | pane numbers flashed on current window (tap number to jump) |

### Panes
| Keys | Action |
|---|---|
| `<L> %` | Split pane **vertically** (left / right) |
| `<L> "` | Split pane **horizontally** (top / bottom) |
| `<L> x` | **Kill** current pane (confirms) |
| `<L> z` | Toggle **zoom** on current pane (fullscreen) |
| `<L> {` / `}` | Swap pane with prev / next |
| `<L> space` | Cycle pane layouts |
| `<L> !` | Break current pane into its own window |
| `<L> q` | Flash pane numbers (tap number to jump) |

### Sessions
| Keys | Action |
|---|---|
| `<L> d` | **Detach** from session (keeps running) |
| `<L> s` | List sessions (picker) |
| `<L> $` | Rename current session |
| `<L> (` / `)` | Previous / next session |

### Misc
| Keys | Action |
|---|---|
| `<L> :` | tmux command prompt |
| `<L> ?` | List all keybindings |
| `<L> t` | Big ASCII clock |

---

## 6. Copy / paste (vi mode)

```
<L> [         enter copy mode
  v           start selection   (vi-style)
  h j k l     move cursor
  w b $ 0     word / line motions
  y           copy to Mac clipboard (pbcopy) and exit
  q           cancel
<L> ]         paste the most recent buffer
```

Mouse is also on — click to focus a pane, drag to select.

---

## 7. Shell commands (`tmux …`)

### Start / attach / detach
```sh
tmux                         # start a new session
tmux new -s <name>           # start a new named session
tmux new -s <name> -d        # start detached in background
tmux attach                  # attach to most recent session
tmux attach -t <name>        # attach to a specific session
tmux a                       # short alias for attach
tmux a -t <name>             # short alias for attach to target
tmux detach                  # detach from inside (same as <L> d)
```

### List / watch
```sh
tmux ls                              # list all sessions
tmux list-sessions                   # same, long form
tmux list-windows                    # windows in the attached session
tmux list-windows -a                 # windows across all sessions
tmux list-panes                      # panes in the current window
tmux list-panes -a                   # panes across every window
tmux list-clients                    # who's attached to what

# live-watch a tmux window/pane
watch -n 1 'tmux list-sessions'      # live session list
watch -n 1 'tmux list-windows -a'    # live window list
tmux capture-pane -p -t <target>     # dump pane contents to stdout
tmux pipe-pane -t <target> 'cat >> ~/pane.log'   # stream pane to file
```

### Send / rename / move / reload
```sh
tmux rename-session -t old new
tmux rename-window -t <target> new-name
tmux send-keys -t <target> 'echo hi' Enter      # type into a pane
tmux move-window -s src:1 -t dst:3              # move window across sessions
tmux swap-window -s src:1 -t dst:2              # swap two windows
tmux source-file ~/.config/tmux/tmux.conf       # reload config from CLI
```

`<target>` examples: `mysession`, `mysession:2` (window 2), `mysession:2.1` (pane 1 of window 2).

---

## 8. Exit / kill patterns

### Exit / detach (keep session running)
- **From inside tmux:** `<L> d` (or `<L> :` then type `detach`)
- **From shell inside a pane:** type `exit` or hit `Ctrl+d`. When the last pane of the last window exits, the session dies.

### Kill a pane
- **Shortcut:** `<L> x` (confirms)
- **Shell:** `tmux kill-pane -t <target>`

### Kill a window
- **Shortcut:** `<L> &` (that's `Ctrl+a`, release, then `Shift+7`; confirms)
- **Shell:** `tmux kill-window -t <target>`

### Kill a session

No default single-key shortcut. Four ways:

1. **Command prompt** — `<L> :` then type `kill-session` (Enter).
2. **Tree picker** — `<L> w`, highlight a session, press `x`.
3. **Shell:**
   ```sh
   tmux kill-session                # current / most recent
   tmux kill-session -t work        # by name
   tmux kill-session -a             # all EXCEPT current
   tmux kill-session -a -t work     # all except "work"
   ```
4. **Add a shortcut** (optional). In `tmux.conf`:
   ```tmux
   bind-key X confirm-before -p "kill session #S? (y/n)" kill-session
   ```
   Then `<L> X` (capital X — lowercase `x` is kill-pane).

### Kill everything
```sh
tmux kill-server                 # nuke every session for this user
```
Or inside tmux: `<L> :` then `kill-server`.

---

## 9. Companion files: `.tmux-cht-*`

Bound to `<L> i` via Primeagen's `tmux-cht.sh` script (cheat.sh lookup helper). The script reads two files from `$HOME`:

| File | Contents |
|---|---|
| `~/.tmux-cht-languages` | Programming languages (go, rust, python, cpp, lua, …). Picking one prompts for a query like "reverse a string" and fetches `cheat.sh/<lang>/<query>`. |
| `~/.tmux-cht-command` | CLI tools (find, grep, jq, docker, git, ssh, …). Picking one fetches usage examples for that command. |

**How it works:** `tmux-cht.sh` shows both lists via `fzf`, then `curl`s `cheat.sh/…` with your query and pipes it into `less`.

**Install (if you want `<L> i` to work):**
```sh
cp ~/.config/tmux_primeagen/.tmux-cht-* ~/
# then get tmux-cht.sh from https://github.com/ThePrimeagen/.dotfiles
# (bin/.local/bin/tmux-cht.sh) and put it on $PATH, chmod +x
```

---

## 10. Typical workflow

```sh
# morning: open your work project
tmux new -s work -c ~/code/myproject
<L> "                 # split: shell on bottom
<L> j                 # jump down to the bottom pane
yarn test --watch
<L> k                 # back to the editor pane
# edit, run, edit…

# boss calls — lunch
<L> d                 # detach. everything keeps running.

# after lunch
tmux a                # reattach to most recent session
# …or pick one:
tmux ls
tmux a -t work

# done for the day
<L> :kill-session     # nuke just this session
# or nuke everything tmux-related:
tmux kill-server
```

Day-to-day muscle memory: `tmux a`, `<L> c` new tab, `<L> "` split, `<L> h/j/k/l` move, `<L> d` leave running.

---

## 11. Running shell commands while editing in nvim

Common question: **"I'm in nvim and want to build/run this file — pane or window?"**

First, a myth-buster: **you don't have to kill a pane to "get it out of the way."** A pane stays alive until you explicitly kill it. Navigate away, zoom over it, or promote it to its own window.

### The cheat-sheet answer

| Situation | Use | Why |
|---|---|---|
| Quick build + run a single file | **Pane** | Output stays visible, zoom if it overflows |
| Repeated compile-test loop | **Pane** | `<L> j`, up-arrow to re-run, `<L> k` |
| Dev server / watcher / forever process | **Window** | Don't want a permanent chunk of screen eaten |
| Multiple related shells at once | **Pane** (split again) | See them side-by-side |
| One-shot command, output doesn't matter | **`:!cmd`** from nvim | Stay in nvim |

### Option 1 — Pane (my default for quick build-run)

```
<L> "        split horizontally — nvim on top, shell on bottom
<L> j        jump down to the shell
g++ main.cpp -o main && ./main
<L> k        back to nvim, keep editing
```

Next iteration: `<L> j`, `↑` to re-run the last command, `<L> k`. You never kill the pane — all your output sits in the history, scroll up with `<L> [` (copy mode).

**When the output is too big to read in the small split — the zoom trick:**

```
<L> j        move to the shell pane
<L> z        ZOOM fullscreen — nvim is still there, just hidden
<L> z        unzoom — back to the split
```

`<L> z` is a **toggle**. Zoom to read an error, unzoom to jump back. nvim's cursor, buffers, everything preserved.

### Option 2 — Window (for long-running stuff)

Use a window when the process runs **forever**: `npm run dev`, `cargo watch -x run`, test watcher, docker compose, dev server.

```
<L> c        new window — fullscreen shell
cargo watch -x run
<L> ^        toggle back to nvim
<L> ^        toggle back to the watcher anytime
```

`<L> ^` is the "flip between last two windows" bind from your config. Window 1 = nvim, window 2 = watcher. You live in `<L> ^`.

### Option 3 — `:!cmd` or `:terminal` from inside nvim

Never leave nvim:

```vim
:!g++ main.cpp -o main && ./main    " runs, shows output, hit Enter to return
:term                                " embedded shell in a new pane
:split | term                        " embedded shell in a horizontal split
```

Good for one-shots. Bad for watchers (`:!` locks the editor; `:term` has clunky mode keys — `Ctrl+\ Ctrl+n` to leave terminal-insert mode).

### Changed your mind? Promote / demote

You started with a pane and want a window instead (or vice versa):

```
<L> !                            Break the current pane into its own window
<L> :join-pane -s :3             Pull window 3 into the current window as a pane
<L> :break-pane                  Same as <L> ! (long form)
```

### The short version

**Default to a pane + `<L> z` zoom trick. Promote to a window only when it outgrows the split.**

---

## 12. Troubleshooting

| Problem | Fix |
|---|---|
| `<L>` doesn't do anything | You're not in tmux, or the config didn't load. Check with `tmux show -g prefix` (should print `prefix C-a`). |
| Colors look washed out | Your terminal must support truecolor. iTerm2 / Ghostty / Alacritty / WezTerm all do. |
| `<L> f` says "command not found" | Install `tmux-sessionizer` to `~/.local/bin/` and `chmod +x` it. |
| `<L> i` says "command not found" | Same — install `tmux-cht.sh` on `$PATH`, plus the `.tmux-cht-*` files in `$HOME`. |
| Forgot a keybind | `<L> ?` lists all of them. `q` to exit. |
| Window number keys don't work | It's `<L> 2` (prefix then number), **not** `<L> a 2` or `<L> Ctrl+a 2`. |
| Want to kill an unattached session fast | `<L> w` → arrow to it → `x`. |

---

## 13. Sanity checks

```sh
tmux source-file ~/.config/tmux/tmux.conf   # or <L> r inside tmux
tmux show -g prefix                         # prints: prefix C-a
tmux list-keys | grep -E 'prefix|C-a'       # confirm leader bindings
tmux ls                                     # see running sessions
```
