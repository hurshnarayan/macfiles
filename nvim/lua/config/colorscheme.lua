-- =============================================================================
-- colorscheme.lua  (Theme)
-- =============================================================================
--
-- Sets the colorscheme. Catppuccin handles its own highlight groups
-- for plugins (blink.cmp, gitsigns, neo-tree, etc.) so we don't need
-- manual highlight overrides anymore.
--
-- TO CHANGE FLAVOUR:
--   Edit lua/plugins/catppuccin.lua and change the flavour value.
--   Options: "mocha", "macchiato", "frappe", "latte"
--
-- TO BROWSE THEMES:
--   :FzfLua colorschemes
-- =============================================================================

vim.cmd.colorscheme("catppuccin")
