-- =============================================================================
-- snacks.lua  (Small UI Improvements)
-- =============================================================================
--
-- snacks.nvim is a collection of small features. We only use indent guides:
-- thin vertical lines that show indentation levels, making nested code
-- easier to read.
-- =============================================================================

require("snacks").setup({
  indent = { enabled = true },  -- show indent guides
  -- Everything else is disabled
  bigfile = { enabled = false },
  dashboard = { enabled = false },
  explorer = { enabled = false },
  input = { enabled = false },
  notifier = { enabled = false },
  picker = { enabled = false },
  quickfile = { enabled = false },
  scope = { enabled = false },
  scroll = { enabled = false },
  statuscolumn = { enabled = false },
  words = { enabled = false },
})
