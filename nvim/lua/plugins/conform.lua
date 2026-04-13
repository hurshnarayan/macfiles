-- =============================================================================
-- conform.lua  (Code Formatter)
-- =============================================================================
--
-- conform.nvim runs code formatters when you press Space lf or on save.
-- It maps each file type to one or more formatters.
--
-- HOW IT WORKS:
--   1. You press Space lf (or format on save)
--   2. conform checks formatters_by_ft for the current filetype
--   3. It runs the formatter(s) on your code
--   4. If no formatter is configured, it falls back to LSP formatting
--
-- ADDING A FORMATTER FOR A NEW LANGUAGE:
--   1. Install the formatter via Mason (:Mason, search for it)
--   2. Add it to mason-tool-installer in lua/plugins/mason.lua
--   3. Add a line below:  your_filetype = { "formatter_name" },
--
-- MULTIPLE FORMATTERS:
--   python = { "isort", "black" }
--   This runs isort first (sorts imports), then black (formats code).
--   They run in sequence, not parallel.
-- =============================================================================

local conform = require("conform")

conform.setup({
  formatters_by_ft = {
    -- C / C++ / Objective-C
    c = { "clang-format" },
    cpp = { "clang-format" },
    objc = { "clang-format" },

    -- Python: sort imports first, then format
    python = { "isort", "black" },

    -- Go: stricter formatting + auto-add imports
    go = { "gofumpt", "goimports" },

    -- JavaScript / TypeScript / Web
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    css = { "prettier" },
    html = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    graphql = { "prettier" },

    -- Lua
    lua = { "stylua" },

    -- Rust
    rust = { "rustfmt" },

    -- Shell scripts
    sh = { "shfmt" },
    bash = { "shfmt" },
    zsh = { "shfmt" },

    -- TOML
    toml = { "taplo" },

    -- Fallback: trim trailing whitespace for any file type
    ["*"] = { "trim_whitespace" },
  },

  -- If no formatter matches, try LSP formatting as a fallback
  default_format_opts = {
    lsp_format = "fallback",
  },

  -- Per-formatter settings
  formatters = {
    shfmt = {
      -- Use 2-space indentation for shell scripts
      prepend_args = { "-i", "2" },
    },
  },
})


-- FORMAT shortcut: Space lf
-- Works in normal mode (formats whole file) and visual mode (formats selection)
vim.keymap.set({ "n", "v" }, "<leader>lf", function()
  conform.format({
    lsp_format = "fallback",
    async = false,
    timeout_ms = 500,
  })
end, { desc = "Format file or range (in visual mode)" })
