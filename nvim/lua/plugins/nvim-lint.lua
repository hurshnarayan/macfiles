-- =============================================================================
-- nvim-lint.lua  (Linter Integration)
-- =============================================================================
--
-- nvim-lint runs external linters and shows their results as diagnostics
-- (the same error/warning signs that LSP uses).
--
-- LINTERS vs LSP:
--   LSP servers often include their own linting (e.g. eslint-lsp, basedpyright).
--   nvim-lint is for standalone linters that aren't LSP servers.
--   You can use both: they'll combine their diagnostics.
--
-- ADDING A LINTER FOR A NEW LANGUAGE:
--   1. Install the linter via Mason or your package manager
--   2. Add it to mason-tool-installer in lua/plugins/mason.lua
--   3. Add a line below:  your_filetype = { "linter_name" },
--
-- WHEN DO LINTERS RUN?
--   Automatically on: BufEnter (open file), BufWritePost (after save),
--   and InsertLeave (leave insert mode).
--   You can also run manually with Space ll.
-- =============================================================================

local lint = require("lint")

-- Map file types to linters
-- NOTE: some languages get linting from their LSP server instead:
--   - JavaScript/TypeScript: eslint LSP
--   - Python: basedpyright LSP (type checking)
--   - Go: gopls LSP
--   - Rust: rust_analyzer LSP
lint.linters_by_ft = {
  -- C / C++: Google C++ style checker
  c = { "cpplint" },
  cpp = { "cpplint" },

  -- Python: pylint for additional style/bug checks beyond type checking
  python = { "pylint" },

  -- Shell scripts: shellcheck finds bugs and portability issues
  sh = { "shellcheck" },
  bash = { "shellcheck" },
  zsh = { "shellcheck" },

  -- Go: golangci-lint runs a suite of Go linters (govet, staticcheck, etc.)
  -- Augments gopls with style / bug checks gopls doesn't cover.
  -- i have it commented cuz two linters are annoying, it flags too many things,
  -- the linter (gopls) official lang server of go does the job

  -- go = { "golangcilint" },

  -- Dockerfile: hadolint checks for best practices and common mistakes
  dockerfile = { "hadolint" },

  -- Markdown: markdownlint-cli2 checks for style issues and broken references
  markdown = { "markdownlint-cli2" },
}

-- Auto-run linters on these events
local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  group = lint_augroup,
  callback = function()
    lint.try_lint()
  end,
})

-- Manual lint trigger: Space ll
vim.keymap.set("n", "<leader>ll", function()
  lint.try_lint()
end, { desc = "Trigger linting for current file" })
