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

-- Swap the modified-buffer glyph in the winbar from the nerd-font  (which
-- renders as a blob) to a plain ●, keeping the existing layout and position.
local bc = require("breadcrumbs")
local bc_utils = require("breadcrumbs.utils")

bc.get_winbar = function()
  if vim.tbl_contains(bc.winbar_filetype_exclude or {}, vim.bo.filetype) then
    return
  end

  local value = bc.get_filename()
  if bc_utils.isempty(value) then
    return
  end

  local ok, navic = pcall(require, "nvim-navic")
  if ok then
    local loc_ok, loc = pcall(navic.get_location, {})
    if loc_ok and navic.is_available() and not bc_utils.isempty(loc) and loc ~= "error" then
      value = value .. " %#NavicSeparator#\239\145\160%* " .. loc
    end
  end

  if bc_utils.get_buf_option("mod") then
    value = value .. " %#DiagnosticWarn#●%*"
  end

  pcall(vim.api.nvim_set_option_value, "winbar", value, { scope = "local" })
end
