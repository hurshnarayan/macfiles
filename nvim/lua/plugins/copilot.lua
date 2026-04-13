-- =============================================================================
-- copilot.lua  (GitHub Copilot AI)
-- =============================================================================
--
-- GitHub Copilot provides AI code suggestions as you type.
-- You need a GitHub Copilot subscription for this to work.
--
-- FIRST-TIME SETUP:
--   Run :Copilot auth  in Neovim to sign in with your GitHub account.
--
-- HOW TO USE:
--   - Just start typing. Ghost text appears with suggestions.
--   - Tab          = accept the suggestion
--   - Ctrl+h       = dismiss the suggestion
--   - Keep typing  = suggestion updates automatically
--   - Ctrl+s       = toggle auto-suggestions on/off
-- =============================================================================

require("copilot").setup({
  panel = {
    keymap = {
      refresh = "r",
      open = "<M-CR>",  -- Alt+Enter to open Copilot panel
    },
  },
  suggestion = {
    enabled = true,
    auto_trigger = true,  -- suggestions appear automatically
    keymap = {
      accept = false,     -- we handle Tab accept below
      dismiss = "<c-h>",  -- Ctrl+h to dismiss suggestion
    },
  },
  filetypes = {
    yaml = true,
    markdown = true,
    help = false,
    gitcommit = false,
    gitrebase = false,
    cvs = false,
    ["."] = false,
  },
  copilot_node_command = "node",
})

local opts = { noremap = true, silent = true }

-- Toggle Copilot auto-trigger with Ctrl+s
vim.api.nvim_set_keymap("n", "<c-s>", ":lua require('copilot.suggestion').toggle_auto_trigger()<CR>", opts)

-- Accept Copilot suggestion with Tab (in insert mode)
-- If no suggestion is visible, Tab inserts a normal tab character
vim.keymap.set("i", "<tab>", function()
  if require("copilot.suggestion").is_visible() then
    require("copilot.suggestion").accept()
    return "<Ignore>"
  end
  return "<tab>"
end, { expr = true, noremap = true })

vim.g.copilot_nes_debounce = 100
