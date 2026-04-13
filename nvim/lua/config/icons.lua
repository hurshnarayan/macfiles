-- =============================================================================
-- icons.lua  (Shared Icon Definitions)
-- =============================================================================
--
-- These icons are used by:
--   - blink.cmp (completion menu: shows icon next to each suggestion type)
--   - breadcrumbs/navic (winbar: shows File > Class > Function path)
--
-- Each key corresponds to an LSP "CompletionItemKind" or symbol type.
-- The values are Nerd Font icons.
--
-- IMPORTANT: These icon characters require a Nerd Font installed.
-- Install it with:  brew install --cask font-symbols-only-nerd-font
-- Then set "Symbols Nerd Font Mono" as a fallback font in your terminal.
--
-- TO FIND MORE ICONS:
--   Run :FzfLua icons inside Neovim
--   Or browse: https://www.nerdfonts.com/cheat-sheet
--
-- NOTE: Claude Code cannot write icon characters reliably.
-- If you need to change icons, edit this file directly in Neovim.
-- =============================================================================

local M = {
  Array = "",
  Boolean = "",
  Class = "",
  Color = "",
  Constant = "",
  Constructor = "",
  Copilot = "",
  Enum = "",
  EnumMember = "",
  Event = "",
  Field = "",
  File = "",
  Folder = "",
  Function = "",
  Interface = "",
  Key = "",
  Keyword = "",
  Method = "",
  Module = "",
  Namespace = "",
  Null = "󰟢",
  Number = "",
  Object = "",
  Operator = "",
  Package = "",
  Property = "",
  Reference = "",
  Snippet = "",
  String = "",
  Struct = "",
  Text = "󰦨",
  TypeParameter = "",
  Unit = "",
  Value = "",
  Variable = "",
}

return M
