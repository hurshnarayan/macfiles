-- =============================================================================
-- lsp/ts_ls.lua  (TypeScript/JavaScript Language Server Config)
-- =============================================================================
--
-- This file is auto-loaded by Neovim 0.12 when the ts_ls server starts.
-- It configures the TypeScript language server with inlay hints and
-- blink.cmp capabilities.
--
-- The file MUST be at:  lsp/<server_name>.lua
-- and MUST return a table with the server configuration.
-- =============================================================================

local blink = require("blink.cmp")

return {
  -- The command to start the server
  cmd = { "typescript-language-server", "--stdio" },

  -- Which file types this server handles
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },

  -- How to find the project root (looks for these files)
  root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },

  -- Server-specific settings
  settings = {
    typescript = {
      tsserver = {
        useSyntaxServer = false,
      },
      -- Inlay hints configuration (shown when enabled with :lua vim.lsp.inlay_hint.enable(true))
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
      includeCompletionsForModuleExports = true,
      quotePreference = "auto",
    },
    javascript = {},
  },

  -- Merge blink.cmp capabilities with default LSP capabilities
  capabilities = vim.tbl_deep_extend(
    "force", {},
    vim.lsp.protocol.make_client_capabilities(),
    blink.get_lsp_capabilities()
  ),
}
