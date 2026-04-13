-- =============================================================================
-- autopairs.lua  (Auto-Close Brackets)
-- =============================================================================
--
-- Automatically inserts the closing bracket/quote/parenthesis when you
-- type the opening one:
--   ( -> ()    [ -> []    { -> {}    " -> ""    ' -> ''
--
-- Also handles smart deletion: pressing Backspace on () deletes both.
-- =============================================================================

require("nvim-autopairs").setup({
  map_char = {
    all = "(",
    tex = "{",
  },
  enable_check_bracket_line = true,
  check_ts = true,  -- use treesitter to check context
  ts_config = {
    lua = { "string", "source" },
    javascript = { "string", "template_string" },
    java = false,
  },
  disable_filetype = { "TelescopePrompt", "spectre_panel" },
  ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], "%s+", ""),
  enable_moveright = true,
  disable_in_macro = false,
  enable_afterquote = true,
  map_bs = true,
  map_c_w = false,
  disable_in_visualblock = false,
  fast_wrap = {
    map = "<M-e>",  -- Alt+e to wrap selection with brackets
    chars = { "{", "[", "(", '"', "'" },
    pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
    offset = 0,
    end_key = "$",
    keys = "qwertyuiopzxcvbnmasdfghjkl",
    check_comma = true,
    highlight = "Search",
    highlight_grey = "Comment",
  },
})
