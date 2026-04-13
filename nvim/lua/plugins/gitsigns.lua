-- =============================================================================
-- gitsigns.lua  (Git Gutter Signs)
-- =============================================================================
--
-- Shows git diff indicators in the left gutter:
--   Green bar  = new lines (added)
--   Yellow bar = changed lines (modified)
--   Red arrow  = deleted lines
--
-- Also provides the git branch name and diff stats used by the statusline.
-- =============================================================================

require("gitsigns").setup({
  signs = {
    add = { text = "\u{2503}" },          -- thick green bar
    change = { text = "\u{254b}" },       -- dotted yellow bar
    delete = { text = "" },              -- red triangle
    topdelete = { text = "" },           -- red triangle
    changedelete = { text = "\u{2503}" }, -- thick bar
  },
  watch_gitdir = {
    interval = 1000,       -- check for changes every second
    follow_files = true,
  },
  attach_to_untracked = true,  -- show signs even for new/untracked files
  current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
  update_debounce = 200,
  max_file_length = 40000,
  preview_config = {
    border = "rounded",
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1,
  },
})
