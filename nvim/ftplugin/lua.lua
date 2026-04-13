-- =============================================================================
-- ftplugin/lua.lua  (Lua-specific settings)
-- =============================================================================
--
-- Files in ftplugin/ are loaded automatically when you open a file of
-- the matching type. This file runs when you open any .lua file.
--
-- We override indentation to 4 spaces for Lua files (instead of the
-- default 2 spaces set in options.lua).
-- =============================================================================

local opt = vim.opt
opt.shiftwidth = 4
opt.tabstop = 4
