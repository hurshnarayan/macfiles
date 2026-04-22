# Sioyek config

This directory holds my user-level sioyek configuration, copied from sylvan's dotfiles
(`~/code/sylvan-config/sioyek/`).

## File layout

- `keys_user.config` — my keybind overrides (only the keys I change; everything else
  falls back to sioyek defaults).
- `prefs_user.config` — my preference overrides (colors, zoom factor, scroll ratio,
  highlight palette, etc.).
- `README.md` — this file.

### Why also in `~/Library/Application Support/Sioyek/`?

On macOS, sioyek reads its config from `~/Library/Application Support/Sioyek/`, **not**
`~/.config/sioyek/`. It has no idea `~/.config/` exists. So something has to bridge the two.

**The real files live here in `~/.config/sioyek/`.** The Library path holds symlinks
back to this directory:

```
~/Library/Application Support/Sioyek/keys_user.config  ->  ~/.config/sioyek/keys_user.config
~/Library/Application Support/Sioyek/prefs_user.config ->  ~/.config/sioyek/prefs_user.config
```

Edit the files here; sioyek reads them through the symlinks.

#### Why this direction (source of truth in `.config`, symlinks in Library)

Three possible layouts, and why I picked this one:

1. **Real files in Library only.** Simplest — sioyek reads them directly, no symlinks.
   But they're buried in `~/Library/Application Support/` where no one manages dotfiles.
   They'd be invisible to a dotfiles repo living in `~/.config/`, and I'd forget they
   exist.
2. **Real files in both places (two copies, no symlinks).** Safest in the sense that
   nothing breaks if one is deleted, but now every edit has to be made (or synced)
   twice. Guaranteed to drift out of sync eventually.
3. **Real files in `.config`, symlinks in Library.** ← what I did. Single source of
   truth, lives alongside the rest of my dotfiles (`fish`, `ghostty`, `nvim`, `tmux`,
   etc.), and sioyek still sees the files because it follows the symlink. The one
   drawback is that if the symlink ever gets deleted, sioyek stops seeing the
   config — but it's trivial to recreate (commands below).

If you'd rather swap to layout #1 or #2 (e.g. you find the symlink indirection
confusing, or you want sioyek to "just work" without relying on the symlink being
intact), you can:

```sh
# Layout #1: real files in Library only (delete the .config copies)
rm "$HOME/Library/Application Support/Sioyek/keys_user.config"   # removes symlink
rm "$HOME/Library/Application Support/Sioyek/prefs_user.config"
mv ~/.config/sioyek/keys_user.config  "$HOME/Library/Application Support/Sioyek/"
mv ~/.config/sioyek/prefs_user.config "$HOME/Library/Application Support/Sioyek/"

# Layout #2: real copies in both (delete symlinks, replace with copies)
rm "$HOME/Library/Application Support/Sioyek/keys_user.config"
rm "$HOME/Library/Application Support/Sioyek/prefs_user.config"
cp ~/.config/sioyek/keys_user.config  "$HOME/Library/Application Support/Sioyek/"
cp ~/.config/sioyek/prefs_user.config "$HOME/Library/Application Support/Sioyek/"
```

#### Recreating the symlinks (layout #3)

If the symlinks ever break or get deleted:

```sh
ln -sf ~/.config/sioyek/keys_user.config  "$HOME/Library/Application Support/Sioyek/keys_user.config"
ln -sf ~/.config/sioyek/prefs_user.config "$HOME/Library/Application Support/Sioyek/prefs_user.config"
```

The rest of the Library dir (`auto.config`, `local.db`, `shared.db`, `last_document_path.txt`)
is sioyek's runtime state — do **not** symlink those; they're machine-local.

## Reloading without restart

`r` is bound to `reload_config` in my keys, so after editing either config file just
press `r` inside sioyek. No restart needed. (The sioyek default for `r` is
`rotate_clockwise` — I've overridden it.)

## Current custom keybinds (from `keys_user.config`)

| Key       | Command                | Notes                                                   |
| --------- | ---------------------- | ------------------------------------------------------- |
| `<C-d>`   | `screen_down`          | Vim-style half-page down (ratio set by `move_screen_ratio` in prefs). |
| `<C-u>`   | `screen_up`            | Vim-style half-page up.                                 |
| `<C-o>`   | `prev_state`           | Jump back in viewing history (like Vim's jumplist).     |
| `<C-i>`   | `next_state`           | Jump forward in viewing history.                        |
| `<C-w>`   | `toggle_titlebar`      | Overrides default `close_window`.                       |
| `J`       | `zoom_in`              | Shift+j. Overrides default (visual-mark down).          |
| `K`       | `zoom_out`             | Shift+k. Overrides default (visual-mark up).            |
| `i`       | `toggle_dark_mode`     | "i" = invert.                                           |
| `c`       | `toggle_custom_color`  | Uses `custom_background_color`/`custom_text_color` from prefs. |
| `r`       | `reload_config`        | Overrides default `rotate_clockwise`.                   |
| `s`       | `fit_to_page_width`    | Overrides default `external_search`.                    |
|           | `helper_window`        | Listed with no key — intentionally unbound.             |

## Keybind syntax

From the sioyek default keys file. The user config supports the same grammar.

```
# Simple
command        k              # plain k
command        K              # shift+k
command        +              # shift+= (whatever the unshifted key is)

# Modifiers
command        <C-k>          # ctrl+k
command        <A-k>          # alt+k
command        <S-k>          # shift+k (same as K)
command        <C-S-k>        # ctrl+shift+k

# Special keys
command        <space>
command        <tab>
command        <backspace>
command        <home> <end> <pageup> <pagedown>
command        <up> <down> <left> <right>
command        <f1> ... <f12>
command        <C-<home>>     # modifier + special key: special key stays wrapped

# Sequences (like Vim)
command        gg             # g then g
command        gt             # g then t
command        g<C-n>Dt       # g, ctrl+n, shift+d, t

# Multiple commands in one binding
cmd1;cmd2;cmd3   <keybinding>

# Unbind a default without rebinding it
some_command                  # command name followed by no key
```

Lines starting with `#` are comments.

## How to add or change a keybind

1. Open `~/.config/sioyek/keys_user.config`.
2. Add a line `command_name <key>` (see syntax above).
3. Save. Inside sioyek, press `r` to reload — no restart.

Examples:

```
# Add: jump to end of document with G (it's a default, but re-stating as an example)
goto_end G

# Change: remap my current J/K zoom to just + and -
zoom_in  +
zoom_out -

# Add a sequence: "zf" to toggle fullscreen
toggle_fullscreen zf

# Run two commands with one key: enter dark mode AND custom color on "I"
toggle_dark_mode;toggle_custom_color I
```

To **remove** one of my overrides, delete the line and reload — sioyek will fall back
to whatever the default is for that key.

If a key I override conflicts with something I actually want, I can either:
- bind the original command to a different key, or
- put the line `<command_name>` with no key to unbind it entirely.

## How to change a preference (colors, zoom factor, etc.)

Edit `~/.config/sioyek/prefs_user.config`, then press `r` in sioyek. Highlights of
what's currently set:

- `background_color` / `dark_mode_background_color` — app background (not PDF).
- `dark_mode_contrast 0.8` — dims whites slightly in dark mode.
- `text_highlight_color` — selection color (currently yellow).
- `search_highlight_color` — search match color (green).
- `zoom_inc_factor 1.2` — how much each `zoom_in`/`zoom_out` step changes zoom.
- `move_screen_ratio 0.5` — what fraction of the screen `screen_down`/`screen_up` jumps (half screen = Vim's C-d).
- `fit_to_page_width_ratio 0.75` — how wide pages fill the window when `fit_to_page_width_ratio` is called.
- `custom_background_color` / `custom_text_color` — what `toggle_custom_color` (my `c` key) swaps to.
- `highlight_color_a` ... `highlight_color_z` — 26 named highlight palettes for the `h<letter>` command.
- `use_legacy_keybinds 0` — keep this at 0 to use the modern `<C-k>` syntax shown above.

Full reference: https://sioyek-documentation.readthedocs.io/

## Default keybinds reference (from `/Applications/sioyek.app/Contents/MacOS/keys.config`)

These are sioyek's defaults. Anything I haven't overridden in my user config still
works with the key listed here. The full authoritative file lives inside the app
bundle; this is an annotated summary.

### Navigation and zoom

| Key                 | Command                          |
| ------------------- | -------------------------------- |
| `gg`, `<C-<home>>`  | `goto_beginning` (prefix w/ number for page: `150gg`) |
| `G`, `<end>`        | `goto_end`                       |
| `<home>`            | `goto_page_with_page_number` (prompts) |
| `^`                 | `goto_left_smart` (ignores margins) |
| `$`                 | `goto_right_smart`               |
| `zz`                | top-right of page (two-column docs) |
| `<left>`/`<right>`  | `move_right`/`move_left` (yes, swapped — that's the default) |
| `<C-<pagedown>>`    | `next_page`                      |
| `<C-<pageup>>`      | `previous_page`                  |
| `<space>`, `<pagedown>`   | `screen_down`              |
| `<S-<space>>`, `<pageup>` | `screen_up`                |
| `gc`                | `next_chapter`                   |
| `gC`                | `prev_chapter`                   |
| `<backspace>`, `<C-<left>>`  | `prev_state` (I also bind `<C-o>`) |
| `<S-<backspace>>`, `<C-<right>>` | `next_state` (I also bind `<C-i>`) |
| `<C-t>`             | `new_window`                     |
| `<C-w>`             | `close_window` (**I override this to `toggle_titlebar`**) |
| `t`                 | `goto_toc`                       |
| `+`                 | `zoom_in` (**I also bind `J`**)  |
| `-`                 | `zoom_out` (**I also bind `K`**) |
| `=`                 | `fit_to_page_width` (**I also bind `s`**) |
| `<f9>`              | `fit_to_page_width`              |
| `<f10>`             | `fit_to_page_width_smart`        |
| `r`                 | `rotate_clockwise` (**I override to `reload_config`**) |
| `R`                 | `rotate_counterclockwise`        |
| `o`                 | `open_document`                  |
| `<C-o>`             | `open_document_embedded` (**I override to `prev_state`**) |
| `<C-S-o>`           | `open_document_embedded_from_current_path` |
| `O`                 | `open_prev_doc`                  |
| `j` / `k`           | `move_visual_mark_down`/`_up` (only active when visual mark is set) |

### Search

| Key          | Command          |
| ------------ | ---------------- |
| `/`, `<C-f>` | `search`         |
| `c/`, `c<C-f>` | `chapter_search` |
| `n`          | `next_item`      |
| `N`          | `previous_item`  |

Search supports a page range prefix: `/<110,135>foo` searches pages 110–135 for "foo".

### Bookmarks

| Key  | Command                     |
| ---- | --------------------------- |
| `b`  | `add_bookmark`              |
| `db` | `delete_bookmark`           |
| `gb` | `goto_bookmark` (this doc)  |
| `gB` | `goto_bookmark_g` (all docs)|

### Highlights

| Key   | Command                                  |
| ----- | ---------------------------------------- |
| `h<a–z>` | `add_highlight` (letter picks color — `highlight_color_*` in prefs) |
| `gh`  | `goto_highlight` (this doc)              |
| `gH`  | `goto_highlight_g` (all docs)            |
| `dh`  | `delete_highlight` (click highlight first) |
| `gnh` | `goto_next_highlight`                    |
| `gNh` | `goto_prev_highlight`                    |

### Marks

| Key          | Command       |
| ------------ | ------------- |
| `m<letter>`  | `set_mark`    |
| `` `<letter> `` | `goto_mark` |

### Portals (link source → destination, like wiki-style cross-refs)

| Key              | Command                        |
| ---------------- | ------------------------------ |
| `p`              | `portal` (first press = source, second = destination) |
| `dp`             | `delete_portal` (nearest to cursor) |
| `gp`, `<tab>`    | `goto_portal`                  |
| `P`, `<S-<tab>>` | `edit_portal`                  |
| `<f12>`          | `toggle_window_configuration`  |

### Misc

| Key     | Command                                  |
| ------- | ---------------------------------------- |
| `<C-c>` | `copy`                                   |
| `<f11>` | `toggle_fullscreen`                      |
| `<f1>`  | `toggle_highlight` (PDF link highlighting) |
| `:`     | `command` (opens command palette)        |
| `s`     | `external_search` (**I override to `fit_to_page_width`**) |
| `<f8>`  | `toggle_dark_mode` (**I also bind `i`**) |
| `<f4>`  | `toggle_synctex`                         |
| `<f6>`  | `toggle_mouse_drag_mode`                 |
| `<f7>`  | `toggle_visual_scroll`                   |
| `<f5>`  | `toggle_presentation_mode`               |
| `l`     | `overview_definition` (visual scroll mode) |
| `<C-]>` | `goto_definition`                        |
| `]`     | `portal_to_definition`                   |
| `q`     | `quit`                                   |
| `f`     | `open_link` (keyboard link follow)       |
| `v`     | `keyboard_select`                        |
| `F`     | `keyboard_smart_jump`                    |

### Unbound commands worth knowing (bind them yourself if useful)

These have no default key but are listed in the defaults file as `<unbound>`:

`goto_left`, `goto_right`, `goto_top_of_page`, `goto_bottom_of_page`, `zoom_in_cursor`,
`zoom_out_cursor`, `fit_to_page_height`, `fit_to_page_height_smart`,
`fit_to_page_width_ratio`, `open_last_document`, `enter_visual_mark_mode`,
`toggle_horizontal_scroll_lock`, `set_select_highlight_type`, `add_highlight_with_current_type`,
`toggle_select_highlight`, `goto_next_highlight_of_type`, `goto_prev_highlight_of_type`,
`toggle_one_window`, `keyboard_overview`, `next_preview`, `previous_preview`,
`goto_overview`, `portal_to_overview`, `goto_selected_text`, `focus_text`,
`smart_jump_under_cursor`, `overview_under_cursor`, `visual_mark_under_cursor`,
`close_overview`, `close_visual_mark`, `import`, `export`, `execute`,
`embed_annotations`, `copy_window_size_config`, `prefs`, `prefs_user`,
`prefs_user_all`, `keys`, `keys_user`, `keys_user_all`, `enter_password`,
`toggle_fastread`, `toggle_statusbar`, `reload`, `set_status_string`,
`clear_status_string`, `toggle_titlebar` (I bind this to `<C-w>`).

Bind any of them the same way as the others, e.g.:

```
keys_user <C-,>        # open my user keys file right from sioyek
toggle_statusbar gs
```

## Custom user commands

Beyond built-in commands, you can define your own shell-out commands in
`prefs_user.config` with `new_command`, then bind them like any built-in. Example:

```
# in prefs_user.config
new_command  _open_in_preview  open -a Preview %{file_path}

# in keys_user.config
_open_in_preview  gP
```

`%{file_path}`, `%{file_name}`, `%{paper_name}` are the common expansions.

## Upstream docs

- User docs: https://sioyek-documentation.readthedocs.io/
- Default keys file (on this machine): `/Applications/sioyek.app/Contents/MacOS/keys.config`
- Default prefs file: `/Applications/sioyek.app/Contents/MacOS/prefs.config`
