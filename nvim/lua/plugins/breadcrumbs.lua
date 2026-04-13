-- =============================================================================
-- breadcrumbs.lua  (Navigation Bar at Top of Window)
-- =============================================================================
--
-- Shows a breadcrumb trail at the top of each window:
--   File > Module > Class > Function
--
-- This uses nvim-navic (which gets data from the LSP server) to show
-- where you are in the code structure. Clicking on breadcrumb items
-- navigates to that location.
-- =============================================================================

local icons = require("config.icons")

-- navic wants a trailing space after each icon
local navic_icons = {}
for k, v in pairs(icons) do
  navic_icons[k] = v .. " "
end

require("nvim-navic").setup({
  icons = navic_icons,
  highlight = true,
  lsp = {
    auto_attach = true,  -- automatically connect to LSP servers
    preference = {
      "templ",
      "ts_ls",
    },
  },
  click = true,       -- breadcrumb items are clickable
  separator = "  ",
  depth_limit = 0,    -- 0 = no limit
  depth_limit_indicator = "..",
})

require("breadcrumbs").setup()
