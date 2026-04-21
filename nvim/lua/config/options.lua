-- =============================================================================
-- options.lua  (Editor Settings)
-- =============================================================================
--
-- These are the core settings that control how Neovim looks and behaves.
-- Each setting is explained below. You can change any value and restart
-- Neovim (or run :source %) to see the effect.
--
-- Reference:  :help vim.opt   or   :help 'option-name'
-- =============================================================================

local opt = vim.opt

-- FILE HANDLING
-- Don't create backup files (foo.txt~). Version control (git) is better.
opt.backup = false

-- Don't create swap files (.foo.txt.swp). Prevents annoying "swap exists" errors.
opt.swapfile = false

-- If another program changes the file, don't block editing.
opt.writebackup = false

-- Enable persistent undo: even after closing a file, you can still undo changes
-- when you reopen it. Undo history is saved to ~/.local/state/nvim/undo/
opt.undofile = true


-- CLIPBOARD
-- Use the system clipboard for all yank/paste operations.
-- This means you can copy in Neovim and paste in Chrome (and vice versa).
-- "unnamedplus" connects to the system clipboard on macOS/Linux.
opt.clipboard = "unnamedplus"


-- SEARCH
-- Highlight all matches when you search with / or ?
opt.hlsearch = true

-- Ignore uppercase/lowercase when searching (e.g. /hello matches "Hello")
opt.ignorecase = true

-- BUT if you type any uppercase letter, search becomes case-sensitive
-- (e.g. /Hello only matches "Hello", not "hello")
opt.smartcase = true


-- INDENTATION
-- When you press Tab, insert spaces instead of a real tab character
opt.expandtab = true

-- How many spaces each indentation level uses (>> and << commands)
opt.shiftwidth = 4

-- How many spaces a Tab key press inserts
opt.tabstop = 4

-- How many spaces Tab/Backspace acts like in insert mode.
-- With this set, Backspace deletes a full indent level in one press.
opt.softtabstop = 4

-- Copy indentation from the line above when starting a new line
opt.autoindent = true

-- Try to be smarter about indentation (e.g. indent after { in C/C++)
opt.smartindent = true

-- What backspace can delete: indent, end-of-line, and before insert point
opt.backspace = "indent,eol,start"


-- UI / APPEARANCE
-- Use 24-bit RGB colors in the terminal (makes themes look correct)
opt.termguicolors = true

-- Highlight the line your cursor is on (makes it easier to find)
opt.cursorline = true

-- Show line numbers on the left side
opt.number = true

-- Show relative line numbers (useful for jumping: 5j goes 5 lines down)
opt.relativenumber = true

-- Width of the line number column
opt.numberwidth = 4

-- Always show the sign column (where git/diagnostic icons appear).
-- "yes" prevents the text from shifting left/right when signs appear.
opt.signcolumn = "yes"

-- Don't wrap long lines. Scroll horizontally instead.
opt.wrap = false

-- Don't show "-- INSERT --" at the bottom (the statusline shows the mode)
opt.showmode = false

-- Height of the command line at the bottom
opt.cmdheight = 1

-- Don't show partial commands in the bottom right
opt.showcmd = false

-- Don't show the ruler (line/col) in the bottom right (statusline does this)
opt.ruler = false

-- Pop-up menu height (for completion menus)
opt.pumheight = 10

-- Slight transparency for popup menus (0 = opaque, 100 = invisible)
opt.pumblend = 10

-- Completion menu options: show menu even for one item, don't auto-select,
-- use a floating popup for documentation
opt.completeopt = { "menuone", "noselect", "popup" }

-- Use rounded borders on floating windows (like hover docs, completion docs)
opt.winborder = "rounded"

-- Don't hide characters in markdown (show backticks, etc.)
opt.conceallevel = 0

-- Show tabs in the tabline only when there are 2+ tabs
opt.showtabline = 1

-- Use a single global statusline at the bottom (not one per split)
opt.laststatus = 3

-- Set the window title to the current directory name
opt.title = true
opt.titlelen = 0


-- SPLITS
-- When you split horizontally (:split), put the new window below
opt.splitbelow = true

-- When you split vertically (:vsplit), put the new window to the right
opt.splitright = true


-- MOUSE
-- Enable mouse support in all modes (click to position cursor, scroll, etc.)
opt.mouse = "a"


-- SCROLLING
-- Minimum lines to keep above/below cursor when scrolling
opt.scrolloff = 0

-- Minimum columns to keep left/right of cursor when scrolling horizontally
opt.sidescrolloff = 8


-- TIMING
-- How long (ms) to wait for a mapped key sequence to complete
-- (e.g. pressing <leader> then waiting for the next key)
opt.timeoutlen = 1000

-- How long (ms) to wait before triggering CursorHold events
-- Lower = faster updates for things like git signs and diagnostics
opt.updatetime = 100


-- MISC
-- Font for GUI Neovim apps (like Neovide)
opt.guifont = "monospace:h17"

-- Replace the ~ characters on empty lines with spaces (cleaner look)
opt.fillchars = vim.opt.fillchars + "eob: "
opt.fillchars:append({ stl = " " })

-- Shorten some messages (e.g. don't show "match 1 of 2" for completion)
opt.shortmess:append("c")

-- Allow h, l, and arrow keys to move to the previous/next line
vim.cmd("set whichwrap+=<,>,[,],h,l")

-- Treat hyphens as part of a word (so ciw on "my-variable" selects all of it)
opt.iskeyword:append("-")

-- Netrw (built-in file browser) settings
vim.g.netrw_banner = 0   -- hide the banner at the top
vim.g.netrw_mouse = 2    -- single-click to open files
