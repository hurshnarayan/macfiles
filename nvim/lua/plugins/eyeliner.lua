-- =============================================================================
-- eyeliner.lua  (Quick Jump Highlighting)
-- =============================================================================
--
-- When you press f, F, t, or T (character jump motions), eyeliner highlights
-- unique characters on the line so you can quickly identify which character
-- to target. Makes horizontal movement much faster.
--
-- USAGE:
--   f{char}  = jump forward to {char}
--   F{char}  = jump backward to {char}
--   t{char}  = jump forward to just before {char}
--   T{char}  = jump backward to just after {char}
-- =============================================================================

require("eyeliner").setup({
  highlight_on_key = true,  -- only highlight when f/F/t/T is pressed
  dim = true,               -- dim non-target characters
  disabled_filetypes = { "neo-tree", "qf" },
})
