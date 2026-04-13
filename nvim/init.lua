-- =============================================================================
-- init.lua  (the ENTRY POINT of your entire Neovim configuration)
-- =============================================================================
--
-- When Neovim starts, it looks for this file at:
--   ~/.config/nvim/init.lua
--
-- Think of this as the "main()" of your editor. It loads every other module
-- in a specific order. The ORDER MATTERS because later modules depend on
-- things set up by earlier ones (e.g. plugins must be installed before
-- their configs can run).
--
-- How Lua modules work in Neovim:
--   require("config.options")  -->  loads  lua/config/options.lua
--   require("config.keymaps")  -->  loads  lua/config/keymaps.lua
--   The dot notation maps to folder separators on disk.
-- =============================================================================

-- 1) Editor options  (tabs, line numbers, clipboard, etc.)
require("config.options")

-- 2) Key mappings  (leader key, window navigation, etc.)
require("config.keymaps")

-- 3) Autocommands  (things that happen automatically, like trimming whitespace)
require("config.autocommands")

-- 4) Plugin manager  (downloads & loads all plugins via vim.pack)
require("config.pack")

-- 5) Colorscheme  (theme + custom highlight tweaks)
require("config.colorscheme")

-- 6) Statusline  (the bar at the bottom showing mode, git, diagnostics)
require("config.statusline")

-- 7) LSP  (Language Server Protocol: code intelligence for every language)
require("config.lsp")

-- 8) Custom functions
require("functions.search-projects")
