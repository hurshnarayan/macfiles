-- =============================================================================
-- blink.lua  (Completion Engine)
-- =============================================================================
--
-- blink.cmp is the completion engine: it shows a popup menu of suggestions
-- as you type. It pulls suggestions from multiple "sources":
--   - copilot: AI code suggestions (highest priority)
--   - lsp: language server completions (functions, variables, types)
--   - path: file path completions (type ./ to see files)
--
-- HOW TO USE THE COMPLETION MENU:
--   Ctrl+j       = move DOWN in the list
--   Ctrl+k       = move UP in the list
--   Enter        = accept the selected completion
--   Ctrl+Space   = manually trigger completion (if it didn't auto-show)
--   Esc          = dismiss the menu
--
-- The icons next to each completion item show what kind of thing it is
-- (function, variable, keyword, etc.). These icons are defined in
-- lua/config/icons.lua.
-- =============================================================================

local icons = require("config.icons")

require("blink.cmp").setup({
  -- Use the shared icons for completion item kinds
  appearance = {
    kind_icons = icons,
  },

  -- Command-line completion (when you type : commands)
  cmdline = {
    keymap = {
      preset = "inherit",
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-k>"] = { "select_prev", "fallback" },
    },
  },

  -- Main completion keybindings
  keymap = {
    preset = "default",
    ["<C-k>"] = { "select_prev", "fallback" },  -- move up in menu
    ["<C-j>"] = { "select_next", "fallback" },  -- move down in menu
    ["<CR>"] = { "select_and_accept", "fallback" },  -- accept selection

    -- UltiSnips Tab integration lives in ftplugin/cpp.lua (buffer-local)
    -- so it takes precedence over blink's buffer-local Tab mapping.
  },

  -- Fuzzy matching settings
  fuzzy = {
    implementation = "prefer_rust_with_warning",
    -- Sort by: exact match first, then score, then alphabetical
    sorts = { "exact", "score", "sort_text" },
  },

  -- Completion behavior
  completion = {
    -- Auto-show the documentation panel next to the menu (signature + description)
    documentation = { auto_show = true, auto_show_delay_ms = 200 },
    list = {
      -- Preselect the top match so <CR> accepts it without navigating first
      selection = { preselect = true, auto_insert = false },
    },
  },

  -- Where completions come from
  -- ORDER matters: higher score_offset = higher priority in the list
  sources = {
    default = { "copilot", "lsp", "path" },
    providers = {
      -- Copilot AI suggestions (highest priority with score_offset = 100)
      copilot = {
        name = "copilot",
        module = "blink-cmp-copilot",
        score_offset = 100,
        async = true,
        transform_items = function(_, items)
          local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
          local kind_idx = #CompletionItemKind + 1
          CompletionItemKind[kind_idx] = "Copilot"
          for _, item in ipairs(items) do
            item.kind = kind_idx
          end
          return items
        end,
      },
    },
  },
})
