-- =============================================================================
-- ftplugin/c.lua  (C-specific settings + compile/run keymaps)
-- =============================================================================
-- Runs only for c buffers. Mirrors ftplugin/cpp.lua but with gcc / -std=c11.
--
-- COMPILE/RUN SHORTCUTS:
--   F8   = compile + run with stdin from ./inp
--   F9   = compile + run (no input redirection, full warnings)
--   F10  = compile + run with stdin from ./inp, full warnings
-- =============================================================================

local opt = vim.opt_local
opt.shiftwidth = 4
opt.tabstop = 4

-- cd into the file's directory first so %:t / %:t:r are relative.
-- Dodges fish choking on ".//Users/..." when the buffer was opened
-- with an absolute path.
local map = function(lhs, cmd)
  local full = "cd %:p:h && " .. cmd
  vim.keymap.set({ "n", "i" }, lhs, "<Esc>:w<CR>:!" .. full .. "<CR>",
    { buffer = 0, silent = false, desc = "c: " .. lhs })
end

-- F8: compile + run, stdin from ./inp
map("<F8>",
  "gcc -fsanitize=address -std=c17 -DONPC -O2 -o %:t:r %:t && ./%:t:r < inp")

-- F9: compile + run (no stdin), with -Wall -Wextra -Wshadow
map("<F9>",
  "gcc -fsanitize=address -std=c17 -Wall -Wextra -Wshadow -DONPC -O2 -o %:t:r %:t && ./%:t:r")

-- F10: compile + run with stdin from ./inp, with full warnings
map("<F10>",
  "gcc -fsanitize=address -std=c17 -Wall -Wextra -Wshadow -DONPC -O2 -o %:t:r %:t && ./%:t:r < inp")
