-- =============================================================================
-- colorizer.lua  (Inline Color Preview)
-- =============================================================================
--
-- Shows actual colors inline in your code:
--   #ff0000  appears with a red background
--   rgb(0, 255, 0)  appears with a green background
--   Tailwind classes like bg-blue-500 show their actual color
-- =============================================================================

require("colorizer").setup({
  user_default_options = {
    names = false,     -- don't colorize color names like "red", "blue"
    names_opts = {
      lowercase = true,
      camelcase = true,
      uppercase = false,
      strip_digits = false,
    },
    names_custom = false,
    RGB = true,        -- #RGB hex
    RGBA = true,       -- #RGBA hex
    RRGGBB = true,     -- #RRGGBB hex
    RRGGBBAA = true,   -- #RRGGBBAA hex
    AARRGGBB = true,   -- 0xAARRGGBB hex
    rgb_fn = true,     -- rgb() and rgba()
    hsl_fn = true,     -- hsl() and hsla()
    css = true,        -- CSS color names
    css_fn = true,     -- CSS functions
    tailwind = true,   -- Tailwind class colors
    tailwind_opts = { update_names = false },
  },
})
