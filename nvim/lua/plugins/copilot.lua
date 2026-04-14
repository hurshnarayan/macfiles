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

-- Tab priority (insert mode):
--   1. UltiSnips: expand snippet trigger, or jump to next placeholder
--   2. Copilot:   accept ghost-text suggestion if visible
--   3. Literal <Tab>
-- S-Tab: jump to previous UltiSnips placeholder, else literal <S-Tab>.
vim.keymap.set("i", "<tab>", function()
  if vim.fn.exists("*UltiSnips#CanExpandSnippet") == 1
    and (vim.fn["UltiSnips#CanExpandSnippet"]() == 1
         or vim.fn["UltiSnips#CanJumpForwards"]() == 1) then
    return vim.api.nvim_replace_termcodes(
      "<Cmd>call UltiSnips#ExpandSnippetOrJump()<CR>", true, true, true)
  end
  if require("copilot.suggestion").is_visible() then
    require("copilot.suggestion").accept()
    return "<Ignore>"
  end
  return "<tab>"
end, { expr = true, noremap = true })

vim.keymap.set("i", "<s-tab>", function()
  if vim.fn.exists("*UltiSnips#CanJumpBackwards") == 1
    and vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
    return vim.api.nvim_replace_termcodes(
      "<Cmd>call UltiSnips#JumpBackwards()<CR>", true, true, true)
  end
  return "<s-tab>"
end, { expr = true, noremap = true })

vim.g.copilot_nes_debounce = 100
