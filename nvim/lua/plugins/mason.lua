-- =============================================================================
-- mason.lua  (Tool Installer)
-- =============================================================================
--
-- Mason is an installer for LSP servers, formatters, linters, and DAP adapters.
-- It downloads and manages these tools in ~/.local/share/nvim/mason/.
--
-- mason-tool-installer automatically installs everything in the
-- ensure_installed list when you start Neovim.
--
-- TO ADD A NEW TOOL:
--   1. Run :Mason to open the Mason UI
--   2. Search for the tool you want (e.g. /clangd)
--   3. Press i to install it
--   4. Add its name to the ensure_installed list below so it auto-installs
--      on a fresh machine
--
-- TOOL TYPES:
--   LSP servers    -> provide completions, go-to-definition, diagnostics
--   Formatters     -> auto-format code (prettier, black, clang-format)
--   Linters        -> check for errors/style issues (eslint, pylint)
--
-- NOTE: The tool name here might differ from the LSP server name.
-- For example, the Mason package "clangd" installs the "clangd" binary,
-- which is used by the "clangd" LSP server in lsp.lua.
-- =============================================================================

require("mason").setup({
  ui = {
    border = "rounded",  -- rounded border on the Mason popup
  },
})

require("mason-tool-installer").setup({
  ensure_installed = {
    -- =============================================
    -- LSP SERVERS (code intelligence)
    -- =============================================

    -- C / C++
    "clangd",             -- fast C/C++ language server from LLVM

    -- Python
    "basedpyright",       -- Python type checker + intellisense (fork of pyright)

    -- Go
    "gopls",              -- official Go language server

    -- JavaScript / TypeScript
    "ts_ls",              -- TypeScript/JavaScript language server
    "eslint",             -- JS/TS linting via LSP

    -- Lua (for editing Neovim configs)
    "lua_ls",             -- Lua language server

    -- Rust
    "rust_analyzer",      -- Rust language server

    -- Web
    "tailwindcss",        -- Tailwind CSS class completions
    "html",               -- HTML language server
    "cssls",              -- CSS language server
    "css_variables",      -- CSS custom properties
    "cssmodules_ls",      -- CSS Modules

    -- DevOps / Config
    "dockerls",           -- Dockerfile support
    "jsonls",             -- JSON with schema validation
    "yamlls",             -- YAML
    "bashls",             -- Bash/shell scripts
    "taplo",              -- TOML
    "lemminx",            -- XML
    "marksman",           -- Markdown
    "nginx_language_server", -- Nginx configs

    -- =============================================
    -- FORMATTERS (auto-format on save or manually)
    -- =============================================

    "prettier",           -- JS/TS/CSS/HTML/JSON/YAML/Markdown
    "stylua",             -- Lua
    "black",              -- Python
    "isort",              -- Python (import sorting)
    "clang-format",       -- C / C++ / Objective-C
    "gofumpt",            -- Go (stricter gofmt)
    "goimports",          -- Go (auto-add missing imports)
    "shfmt",              -- Shell scripts

    -- =============================================
    -- LINTERS (find bugs and style issues)
    -- =============================================

    "pylint",             -- Python linter
    "cpplint",            -- C/C++ style linter (Google style)
    "shellcheck",         -- Shell script analyzer
  },
})
