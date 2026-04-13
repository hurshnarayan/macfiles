-- =============================================================================
-- keymaps.lua  (Key Bindings)
-- =============================================================================
--
-- This file defines all custom keyboard shortcuts.
--
-- HOW KEYMAPS WORK:
--   vim.keymap.set(MODE, KEY, ACTION, OPTIONS)
--
--   MODE can be:
--     "n" = Normal mode  (when you're just navigating, not typing)
--     "i" = Insert mode  (when you're typing text)
--     "v" = Visual mode  (when you've selected text with v)
--     "x" = Visual block mode  (when you've selected with Ctrl-v)
--     "t" = Terminal mode  (inside :terminal)
--     { "n", "v" } = multiple modes at once
--
--   OPTIONS:
--     noremap = true   means "don't let other mappings interfere"
--     silent  = true   means "don't show the command in the command line"
--     desc    = "..."  shows up in which-key popup and :map listings
--
-- LEADER KEY:
--   The <leader> key is like a "prefix" for custom shortcuts.
--   We set it to Space, so <leader>ff means: press Space, then f, then f.
--   This gives us hundreds of shortcuts without conflicting with built-in keys.
-- =============================================================================

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Set Space as the leader key (must be done before any <leader> mappings)
keymap("n", "<Space>", "", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Preserve Ctrl-i (jump forward) since Tab and Ctrl-i share the same keycode
-- Without this, remapping Tab would break Ctrl-i
keymap("n", "<C-i>", "<C-i>", opts)


-- =============================================================================
-- WINDOW NAVIGATION (moving between splits)
-- =============================================================================
-- Use Alt+h/j/k/l to move between split windows
-- (On Mac, Alt is the Option key. Make sure your terminal sends Option as Meta.)
--
--   Alt+h = go to the window on the LEFT
--   Alt+j = go to the window BELOW
--   Alt+k = go to the window ABOVE
--   Alt+l = go to the window on the RIGHT
--   Alt+Tab = switch to the last file you were editing (alternate buffer)
keymap("n", "<m-h>", "<C-w>h", opts)
keymap("n", "<m-j>", "<C-w>j", opts)
keymap("n", "<m-k>", "<C-w>k", opts)
keymap("n", "<m-l>", "<C-w>l", opts)
keymap("n", "<m-tab>", "<c-6>", opts)


-- =============================================================================
-- SEARCH: center screen after jumping to search results
-- =============================================================================
-- After pressing n/N/* /# to jump to search results, the screen
-- automatically centers on the match so you don't lose your place
keymap("n", "n", "nzz", opts)
keymap("n", "N", "Nzz", opts)
keymap("n", "*", "*zz", opts)
keymap("n", "#", "#zz", opts)
keymap("n", "g*", "g*zz", opts)
keymap("n", "g#", "g#zz", opts)


-- =============================================================================
-- VISUAL MODE: stay in indent mode
-- =============================================================================
-- Normally when you indent a selection with > or <, it exits visual mode.
-- This remapping keeps you in visual mode so you can indent multiple times.
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)


-- =============================================================================
-- PASTE / DELETE without overwriting clipboard
-- =============================================================================
-- When you paste over a selection (in visual mode), don't replace the
-- clipboard with the deleted text. This way you can paste the same thing
-- multiple times.
keymap("x", "p", [["_dP]])

-- When you press x to delete a single character, don't put it in the clipboard.
-- (You probably don't want single characters cluttering your paste register.)
keymap("n", "x", '"_x')


-- =============================================================================
-- COMMENTING  (toggle comments with Space + /)
-- =============================================================================
-- Uses Neovim's built-in gc/gcc commenting (enhanced by ts-comments plugin
-- for JSX/TSX support).
--   Normal mode:  Space /  = toggle comment on current line
--   Visual mode:  Space /  = toggle comment on selected lines
keymap("n", "<leader>/", "gcc", { remap = true, desc = "Comment line" })
keymap("x", "<leader>/", "gc", { remap = true, desc = "Comment selection" })
keymap("v", "<leader>/", "gc", { remap = true, desc = "Comment selection" })


-- =============================================================================
-- RIGHT-CLICK CONTEXT MENU (mouse support)
-- =============================================================================
-- Right-click shows a menu with "Go to Definition" and "References"
vim.cmd([[:amenu 10.100 mousemenu.Goto\ Definition <cmd>lua vim.lsp.buf.definition()<CR>]])
vim.cmd([[:amenu 10.110 mousemenu.References <cmd>lua vim.lsp.buf.references()<CR>]])
vim.keymap.set("n", "<RightMouse>", "<cmd>:popup mousemenu<CR>")
vim.keymap.set("n", "<Tab>", "<cmd>:popup mousemenu<CR>")


-- =============================================================================
-- LINE NAVIGATION (for wrapped lines, e.g. Tailwind classes)
-- =============================================================================
-- j/k normally skip entire wrapped lines. gj/gk move by visual lines.
-- This makes j/k behave like gj/gk so navigation feels natural with wrapped text.
keymap({ "n", "x" }, "j", "gj", opts)
keymap({ "n", "x" }, "k", "gk", opts)


-- =============================================================================
-- TAB NAVIGATION
-- =============================================================================
-- Tabs in Neovim are like "workspaces" that each hold a layout of windows.
--
--   Shift+Tab    = open current file in a new tab (useful for full-screen editing)
--   Shift+h      = go to previous tab
--   Shift+l      = go to next tab
keymap("n", "<s-tab>", "<cmd>tabnew %<cr>", opts)
keymap({ "n" }, "<s-h>", "<cmd>tabp<cr>", opts)
keymap({ "n" }, "<s-l>", "<cmd>tabn<cr>", opts)


-- =============================================================================
-- MOVE LINES UP / DOWN
-- =============================================================================
-- Alt+j / Alt+k moves the current line (or selected lines) up/down.
-- Works in Normal, Insert, and Visual mode.
keymap("n", "<leader>j", "<cmd>m .+1<CR>==", { desc = "Move line down" })
keymap("n", "<leader>k", "<cmd>m .-2<CR>==", { desc = "Move line up" })
keymap("v", "<leader>j", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap("v", "<leader>k", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })


-- =============================================================================
-- TERMINAL MODE
-- =============================================================================
-- When inside a :terminal buffer, press Ctrl+; to go back to normal mode
-- (normally you'd have to press Ctrl+\ then Ctrl+n, which is awkward)
vim.api.nvim_set_keymap("t", "<C-;>", "<C-\\><C-n>", opts)
