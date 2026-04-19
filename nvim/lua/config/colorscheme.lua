-- =============================================================================
-- colorscheme.lua  (Theme)
-- =============================================================================
--
-- Default: vague (sylvan's theme — muted earthy palette, matches ghostty).
--
-- TO SWITCH THEMES (at runtime):
--   :colorscheme vague
--   :colorscheme catppuccin-mocha
--   :colorscheme jellybeans
--   :FzfLua colorschemes     <- browse all
--
-- The ColorScheme autocmd below force-clears the background on comment
-- highlight groups for EVERY theme, so the brown block-highlight on
-- comments is killed regardless of which theme is active.
-- =============================================================================

-- Force no background on comment highlight groups, for any colorscheme.
-- Using :highlight (not nvim_set_hl) so we only modify bg, preserving
-- the theme's fg/italic/underline attributes.
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    for _, grp in ipairs({
      "Comment",
      "@comment",
      "@comment.lua",
      "@comment.line",
      "@comment.block",
      "@comment.documentation",
      "@spell",
      "@nospell",
      -- Kill Vague's block-background on string literals
      "String",
      "@string",
      "@string.documentation",
      "@string.escape",
      "@string.special",
      "@string.regexp",
    }) do
      vim.cmd("highlight " .. grp .. " guibg=NONE ctermbg=NONE")
    end
  end,
})

vim.cmd.colorscheme("vague")
