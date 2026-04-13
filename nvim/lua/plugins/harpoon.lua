-- =============================================================================
-- harpoon.lua  (Quick File Bookmarks)
-- =============================================================================
--
-- Harpoon lets you "mark" files you frequently jump to, then instantly
-- switch between them. Think of it as bookmarks for your most-used files.
--
-- HOW TO USE:
--   m        = mark/bookmark the current file (shows a notification)
--   Shift+M  = open the harpoon quick menu (list of all bookmarked files)
--              In the menu: navigate with j/k, Enter to open, dd to remove
-- =============================================================================

local harpoon = require("harpoon")

harpoon:setup()

-- Mark current file (adds to harpoon list)
vim.keymap.set("n", "m", function()
  harpoon:list():add()
  vim.notify("\u{f1c45}  marked file")
end)

-- Open harpoon quick menu (see all marked files)
vim.keymap.set("n", "<S-m>", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end)
