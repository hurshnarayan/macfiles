-- =============================================================================
-- autocommands.lua  (Automatic Behaviors)
-- =============================================================================
--
-- Autocommands (autocmds) are actions that run automatically when certain
-- EVENTS happen. For example:
--   "When a file is saved" -> trim trailing whitespace
--   "When Neovim is resized" -> rebalance split windows
--
-- HOW THEY WORK:
--   vim.api.nvim_create_autocmd("EVENT_NAME", {
--     pattern = "*.lua",            -- which files (optional, * = all)
--     group = some_augroup,         -- prevents duplicates on reload
--     callback = function() ... end -- what to do
--   })
--
-- AUGROUPS:
--   An "augroup" is a named group of autocmds. When you reload your config,
--   { clear = true } deletes old autocmds in that group first, so you don't
--   get duplicate autocmds stacking up.
--
-- COMMON EVENTS:
--   BufWritePre   = right before a file is saved
--   BufReadPost   = right after a file is read
--   BufWinEnter   = when a buffer is displayed in a window
--   FileType      = when Neovim detects the file type
--   VimResized    = when you resize your terminal window
--   CursorHold    = cursor hasn't moved for 'updatetime' milliseconds
--   TextYankPost  = after you yank (copy) text
-- =============================================================================

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local general = augroup("General", { clear = true })


-- TRIM TRAILING WHITESPACE on every save
-- Whitespace at the end of lines is usually accidental and causes noisy diffs.
autocmd("BufWritePre", {
  group = general,
  pattern = "*",
  callback = function()
    -- Save cursor position so it doesn't jump after the substitution
    local save_cursor = vim.fn.getpos(".")
    -- The substitution: find one or more spaces (\s\+) at end of line ($),
    -- replace with nothing. The /e flag means "don't error if no match."
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
  desc = "Remove trailing whitespace",
})


-- AUTO-RESIZE splits when terminal window is resized
-- Without this, splits become uneven when you resize your terminal.
autocmd("VimResized", {
  group = general,
  pattern = "*",
  command = "wincmd =",
  desc = "Auto-resize splits",
})


-- RETURN TO LAST EDIT POSITION when reopening a file
-- Neovim remembers where your cursor was (stored in ShaDa file).
-- This autocmd jumps back to that position when you reopen the file.
autocmd("BufReadPost", {
  group = general,
  pattern = "*",
  callback = function()
    -- Get the position of the " mark (last cursor position in this buffer)
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    -- Only jump if the line number is valid
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(0) then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
  desc = "Return to last edit position",
})


-- AUTO-CREATE DIRECTORIES when saving a file
-- If you do :e some/new/deep/path/file.txt and those folders don't exist,
-- this creates them automatically when you save.
autocmd("BufWritePre", {
  group = general,
  pattern = "*",
  callback = function(event)
    -- Don't create dirs for URLs like scp://host/path
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    -- mkdir -p: create parent directories as needed
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
  desc = "Auto-create directories",
})


-- DISABLE AUTO-COMMENTING on new lines
-- By default, Neovim continues comment characters when you press Enter
-- on a comment line. This disables that behavior.
autocmd({ "BufWinEnter" }, {
  callback = function()
    vim.cmd("set formatoptions-=cro")
  end,
})


-- CLOSE SPECIAL BUFFERS with 'q'
-- In these buffer types (help pages, quickfix list, git, etc.),
-- pressing q closes the window instead of recording a macro.
autocmd({ "FileType" }, {
  pattern = {
    "netrw", "Jaq", "qf", "git", "help", "man",
    "lspinfo", "oil", "spectre_panel", "lir",
    "DressingSelect", "tsplayground", "query", "",
  },
  callback = function()
    vim.cmd([[
      nnoremap <silent> <buffer> q :close<CR>
      set nobuflisted
    ]])
  end,
})


-- AUTO-CLOSE the command-line window
-- The command-line window (opened accidentally with q:) is rarely useful.
-- This immediately closes it.
autocmd({ "CmdWinEnter" }, {
  callback = function()
    vim.cmd("quit")
  end,
})


-- REBALANCE TABS when resized
autocmd({ "VimResized" }, {
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})


-- CHECK if file changed externally
-- When you switch to a buffer, check if the file was modified outside Neovim.
autocmd({ "BufWinEnter" }, {
  pattern = { "*" },
  callback = function()
    vim.cmd("checktime")
  end,
})


-- SET WINDOW TITLE to current directory name
autocmd({ "BufWinEnter" }, {
  pattern = { "*" },
  callback = function()
    local dirname = vim.fn.getcwd():match("([^/]+)$")
    vim.opt.titlestring = dirname
  end,
})


-- ENABLE WRAP and SPELL CHECK for prose files
autocmd({ "FileType" }, {
  pattern = { "gitcommit", "markdown", "NeogitCommitMessage" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})


-- CLEAN UP LUASNIP snippets when cursor is idle
-- Prevents stale snippet sessions from lingering
autocmd({ "CursorHold" }, {
  callback = function()
    local status_ok, luasnip = pcall(require, "luasnip")
    if not status_ok then
      return
    end
    if luasnip.expand_or_jumpable() then
      vim.cmd([[silent! lua require("luasnip").unlink_current()]])
    end
  end,
})
