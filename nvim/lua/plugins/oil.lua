-- =============================================================================
-- oil.lua  (File System as a Buffer)
-- =============================================================================
--
-- Oil lets you edit your filesystem like a text buffer. Press - to open
-- the parent directory, then you can rename files by editing text,
-- delete files by deleting lines, etc. Changes are applied when you save.
--
-- SHORTCUT:
--   -  (minus key) = open parent directory in a floating window
-- =============================================================================

require("oil").setup({
  default_file_explorer = false,
  float = {
    max_height = 20,
    max_width = 60,
  },
  view_options = {
    show_hidden = true,  -- show dotfiles
  },
})

vim.keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })
