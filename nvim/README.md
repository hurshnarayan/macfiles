# Neovim Config

## nvim-surround cheat sheet

Normal mode:

| Keys     | Action                                         |
|----------|------------------------------------------------|
| `ysiw"`  | surround inner word with `"`                   |
| `ysiw'`  | surround inner word with `'`                   |
| `yss)`   | surround the whole line with `(` `)` (tight)   |
| `yss(`   | surround the whole line with `( )` (w/ spaces) |
| `ys$)`   | surround from cursor to end of line            |
| `cs"'`   | change surrounding `"` to `'`                  |
| `cs'<q>` | change surrounding `'` to `<q></q>`            |
| `ds"`    | delete surrounding `"`                         |

Visual mode:

| Keys | Action                      |
|------|-----------------------------|
| `S"` | wrap the selection with `"` |

Opening vs closing bracket: `)` = tight, `(` = adds spaces inside.
