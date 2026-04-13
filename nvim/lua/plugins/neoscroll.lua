-- =============================================================================
-- neoscroll.lua  (Smooth Scrolling)
-- =============================================================================
--
-- Adds smooth animation when scrolling with Ctrl+j/k/u/d/b/f.
-- Without this, scrolling is instant (jumps), which can be disorienting.
--
-- SCROLL KEYS:
--   Ctrl+j  = scroll down half page (smooth)
--   Ctrl+k  = scroll up half page (smooth)
--   Ctrl+d  = scroll down half page (smooth)
--   Ctrl+u  = scroll up half page (smooth)
--   Ctrl+f  = scroll down full page (smooth)
--   Ctrl+b  = scroll up full page (smooth)
--   zt      = scroll so cursor is at top (smooth)
--   zz      = scroll so cursor is at center (smooth)
--   zb      = scroll so cursor is at bottom (smooth)
-- =============================================================================

-- Remap Ctrl+j/k to half-page scroll (before neoscroll overrides them)
vim.cmd([[
  nnoremap <C-j> <C-D>
  vnoremap <C-j> <C-D>

  nnoremap <C-k> <C-U>
  vnoremap <C-k> <C-U>
]])

require("neoscroll").setup({
  mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb", "C-k", "C-j" },
  hide_cursor = true,
  stop_eof = true,
  respect_scrolloff = false,
  cursor_scrolls_alone = true,
  easing_function = nil,
  pre_hook = nil,
  post_hook = nil,
  performance_mode = false,
})

-- Define scroll durations (last number = animation duration in ms)
local t = {}
t["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "250" } }
t["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "250" } }
t["<C-k>"] = { "scroll", { "-vim.wo.scroll", "true", "250" } }
t["<C-j>"] = { "scroll", { "vim.wo.scroll", "true", "250" } }
t["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "450" } }
t["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "450" } }
t["<C-y>"] = { "scroll", { "-0.10", "false", "100" } }
t["<C-e>"] = { "scroll", { "0.10", "false", "100" } }
t["zt"] = { "zt", { "250" } }
t["zz"] = { "zz", { "250" } }
t["zb"] = { "zb", { "250" } }

require("neoscroll.config").set_mappings(t)
