-- =============================================================================
-- ftplugin/cpp.lua  (C++-specific settings + compile/run keymaps)
-- =============================================================================
-- Runs only for cpp buffers. Keymaps are buffer-local so they don't leak
-- into other filetypes.
--
-- COMPILE/RUN SHORTCUTS (ported from MacVim vimrc):
--   F8   = compile + run with stdin from ./inp
--   F9   = compile + run (no input redirection, full warnings)
--   F10  = compile + run with stdin from ./inp, full warnings
--
-- All use -include-pch for fast compilation via the precompiled bits/stdc++.h
-- (built during MacVim setup; lives in the CLT SDK include path).
-- =============================================================================

local opt = vim.opt_local
opt.shiftwidth = 4
opt.tabstop = 4

-- Buffer-local Tab / S-Tab that beat blink.cmp's Tab. blink.cmp attaches
-- to the buffer later than ftplugin runs, so we defer our mapping via
-- InsertEnter (first time only) + vim.schedule so ours is the last one
-- set and therefore the one that fires.
local function set_tab_maps(buf)
  -- expr mapping with replace_keycodes=true (nvim default when expr=true):
  -- return raw strings like "<Plug>(ultisnips_expand)" and Vim converts
  -- them to the real keycodes. DO NOT pre-encode with nvim_replace_termcodes.
  vim.keymap.set("i", "<Tab>", function()
    if vim.fn["UltiSnips#CanExpandSnippet"]()
      or vim.fn["UltiSnips#CanJumpForwards"]() then
      return "<Plug>(ultisnips_expand)"
    end
    local ok, cs = pcall(require, "copilot.suggestion")
    if ok and cs.is_visible() then
      cs.accept()
      return ""
    end
    return "<Tab>"
  end, { buffer = buf, expr = true, desc = "UltiSnips / Copilot / Tab" })

  vim.keymap.set("i", "<S-Tab>", function()
    if vim.fn["UltiSnips#CanJumpBackwards"]() then
      return "<Plug>(ultisnips_jump_backward)"
    end
    return "<S-Tab>"
  end, { buffer = buf, expr = true, desc = "UltiSnips jump back / S-Tab" })
end

vim.api.nvim_create_autocmd("InsertEnter", {
  buffer = 0,
  once = true,
  callback = function(ev)
    vim.schedule(function() set_tab_maps(ev.buf) end)
  end,
})

-- Path to precompiled bits/stdc++.h (built for Apple clang)
local PCH = "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/c++/v1/bits/stdc++.h.gch"
local PCH_FLAG = "-include-pch " .. PCH

-- cd into the file's directory first so %:t / %:t:r are relative.
-- This dodges fish choking on ".//Users/..." when the buffer was opened
-- with an absolute path.
local map = function(lhs, cmd)
  local full = "cd %:p:h && " .. cmd
  vim.keymap.set({ "n", "i" }, lhs, "<Esc>:w<CR>:!" .. full .. "<CR>",
    { buffer = 0, silent = false, desc = "cpp: " .. lhs })
end

-- F8: compile + run, stdin from ./inp
map("<F8>",
  "g++ " .. PCH_FLAG .. " -fsanitize=address -std=c++17 -DONPC -O2 -o %:t:r %:t && ./%:t:r < inp")

-- F9: compile + run (no stdin), with -Wall -Wextra -Wshadow
map("<F9>",
  "g++ " .. PCH_FLAG .. " -fsanitize=address -std=c++17 -Wall -Wextra -Wshadow -DONPC -O2 -o %:t:r %:t && ./%:t:r")

-- F10: compile + run with stdin from ./inp, with full warnings
map("<F10>",
  "g++ " .. PCH_FLAG .. " -fsanitize=address -std=c++17 -Wall -Wextra -Wshadow -DONPC -O2 -o %:t:r %:t && ./%:t:r < inp")
