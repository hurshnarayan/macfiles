-- =============================================================================
-- nvim-treesitter.lua  (Syntax Highlighting & Code Parsing)
-- =============================================================================
--
-- Treesitter parses your code into a syntax tree, enabling:
--   - Accurate syntax highlighting (better than regex-based highlighting)
--   - Smart code folding
--   - Better indentation
--   - Text objects (select inside a function, class, etc.)
--
-- HOW IT WORKS:
--   Treesitter needs a "parser" for each language. When you open a file,
--   Neovim checks if a parser exists for that language. If it does, it
--   uses treesitter for highlighting. If not, it falls back to regex.
--
-- INSTALLING PARSERS:
--   :TSInstall c cpp python go lua javascript typescript tsx
--   :TSInstall all                  (install everything)
--   :TSUpdate                       (update all installed parsers)
--
-- In Neovim 0.12, treesitter highlighting is started natively (no plugin
-- needed), but the plugin helps manage parser installation.
-- =============================================================================

-- Set up the treesitter plugin (needed for :TSInstall and :TSUpdate)
require("nvim-treesitter.config").setup()

-- Start treesitter highlighting automatically for any file with a parser
-- This replaces the old require("nvim-treesitter.configs").setup({ highlight = {...} })
vim.api.nvim_create_autocmd("FileType", {
  callback = function(ev)
    -- pcall = "protected call" - if treesitter doesn't have a parser for
    -- this filetype, it just silently skips instead of showing an error
    local ok = pcall(vim.treesitter.start, ev.buf)
    if not ok then
      return
    end
  end,
})
