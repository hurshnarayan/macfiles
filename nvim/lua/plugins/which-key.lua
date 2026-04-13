-- =============================================================================
-- which-key.lua  (Keybinding Helper Popup)
-- =============================================================================
--
-- When you press a key prefix (like Space) and pause, a popup appears
-- showing all available keybindings that start with that prefix.
--
-- This is extremely helpful for learning keybindings!
-- Just press Space and wait ~300ms to see all Space+... shortcuts.
--
-- The groups below organize shortcuts into categories in the popup.
-- =============================================================================

vim.o.timeout = true
vim.o.timeoutlen = 300  -- show popup after 300ms of waiting

local wk = require("which-key")

wk.setup({
  preset = "helix",  -- compact layout style
  plugins = {
    marks = true,      -- show marks in the popup
    registers = true,  -- show registers in the popup
    spelling = {
      enabled = true,
      suggestions = 20,
    },
    presets = {
      operators = false,
      motions = false,
      text_objects = false,
      windows = false,
      nav = false,
      z = false,
      g = false,
    },
  },
  win = {
    border = "rounded",
    no_overlap = false,
    padding = { 0, 2 },
    title = false,
    title_pos = "center",
    zindex = 1000,
  },
  show_help = false,
  show_keys = false,
  disable = { buftypes = {} },
})

-- Define group names for the which-key popup
wk.add({
  { "<leader>c", group = "code" },
  { "<leader>e", group = "explorer" },
  { "<leader>f", group = "find" },
  { "<leader>l", group = "LSP" },
  { "<leader>r", group = "rename/restart" },
  { "<leader>D", desc = "Buffer diagnostics" },
  { "<leader>d", desc = "Line diagnostics" },
})
