-- =============================================================================
-- project.lua  (Auto-Detect Project Root)
-- =============================================================================
--
-- Automatically sets the working directory to the project root when you
-- open a file. It detects the root by looking for .git, .hg, etc.
-- This means :FzfLua files searches from the project root, not the
-- directory you launched Neovim from.
-- =============================================================================

require("project_nvim").setup({
  active = true,
  manual_mode = false,
  detection_methods = { "pattern" },  -- detect by file patterns (not LSP)
  patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn" },
  ignore_lsp = {},
  exclude_dirs = {},
  show_hidden = false,
  silent_chdir = true,    -- don't show a message when changing directory
  scope_chdir = "global", -- change directory globally (not per-tab)
})
