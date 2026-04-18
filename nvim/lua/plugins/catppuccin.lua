-- =============================================================================
-- catppuccin.lua  (Colorscheme)
-- =============================================================================
--
-- Catppuccin is a warm pastel theme with 4 flavours:
--   - mocha     (dark, warm)      <-- default
--   - macchiato (dark, slightly lighter)
--   - frappe    (medium dark)
--   - latte     (light theme)
--
-- The color_overrides below shift the mocha palette from its default
-- blue-grey tones to warmer, true coffee/brown tones.
--
-- Change the flavour below to switch. Or browse with :FzfLua colorschemes
-- =============================================================================

require("catppuccin").setup({
  flavour = "mocha",
  transparent_background = false,
  term_colors = true,

  -- Override mocha colors to be warmer / more coffee-toned
  color_overrides = {
    mocha = {
      base     = "#1a1614",  -- main background (dark espresso)
      mantle   = "#161210",  -- slightly darker (sidebar, statusline bg)
      crust    = "#120e0c",  -- darkest (borders, edges)
      surface0 = "#2a2420",  -- subtle UI elements
      surface1 = "#3a322c",  -- inactive elements
      surface2 = "#4a4038",  -- comments, secondary text
      overlay0 = "#6a5e54",  -- line numbers, fold markers
      overlay1 = "#7a6e64",  -- secondary info
      overlay2 = "#8a7e74",  -- tertiary info
      text     = "#e0d6cc",  -- main text (warm white)
      subtext0 = "#b8a898",  -- dimmed text
      subtext1 = "#c8b8a8",  -- slightly dimmed text
    },
  },

  integrations = {
    blink_cmp = true,
    gitsigns = true,
    neotree = true,
    treesitter = true,
    which_key = true,
    native_lsp = {
      enabled = true,
    },
  },

  custom_highlights = function(colors)
    return {
      Comment              = { fg = colors.overlay2, bg = "NONE", style = { "italic" } },
      ["@comment"]         = { fg = colors.overlay2, bg = "NONE" },
      ["@comment.lua"]     = { bg = "NONE" },
      ["@comment.line"]    = { bg = "NONE" },
      ["@comment.block"]   = { bg = "NONE" },
      ["@comment.documentation"] = { bg = "NONE" },
      ["@spell"]           = { bg = "NONE" },
      ["@nospell"]         = { bg = "NONE" },
    }
  end,
})
