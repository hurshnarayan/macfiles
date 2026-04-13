-- =============================================================================
-- bqf.lua  (Better Quickfix List)
-- =============================================================================
--
-- Enhances the quickfix list with a preview window, filtering, and more.
-- The quickfix list shows search results, diagnostics, grep results, etc.
--
-- SHORTCUTS:
--   Space qq  = toggle quickfix list open/closed
--   Space qc  = clear quickfix list
--
-- INSIDE QUICKFIX:
--   o     = open file
--   t     = open in new tab
--   s     = open in split
--   v     = open in vertical split
--   p     = toggle preview for current item
--   a     = toggle auto-preview
--   f/F   = filter results
--   c     = clear selection
--   q     = close
-- =============================================================================

require("bqf").setup({
  auto_enable = true,
  magic_window = true,
  auto_resize_height = false,
  preview = {
    auto_preview = false,
    show_title = true,
    delay_syntax = 50,
    wrap = false,
  },
  func_map = {
    tab = "t",
    openc = "o",
    drop = "O",
    split = "s",
    vsplit = "v",
    stoggleup = "M",
    stoggledown = "m",
    stogglevm = "m",
    filterr = "f",
    filter = "F",
    prevhist = "<",
    nexthist = ">",
    sclear = "c",
    ptoggleitem = "p",
    ptoggleauto = "a",
    ptogglemode = "P",
  },
})

-- Clear the quickfix list and close it
vim.keymap.set("n", "<leader>qc", function()
  vim.fn.setqflist({})
  vim.cmd("cclose")
end, { desc = "Clear quickfix list" })

-- Toggle quickfix list
local function toggle_quickfix()
  local windows = vim.fn.getwininfo()
  for _, win in pairs(windows) do
    if win["quickfix"] == 1 then
      vim.cmd("cclose")
      return
    end
  end
  vim.cmd("copen")
end

vim.keymap.set("n", "<leader>qq", toggle_quickfix, { desc = "Toggle quickfix list" })
