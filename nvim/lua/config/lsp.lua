-- =============================================================================
-- lsp.lua  (Language Server Protocol Configuration)
-- =============================================================================
--
-- LSP is what gives you "IDE features" for each programming language:
--   - Go to definition (jump to where a function is defined)
--   - Find references (find everywhere a function is used)
--   - Hover documentation (press K to see docs for what's under your cursor)
--   - Code actions (auto-fix imports, extract function, etc.)
--   - Rename symbol (rename a variable everywhere it's used)
--   - Diagnostics (red squiggles for errors, yellow for warnings)
--   - Completions (suggestions as you type)
--
-- HOW IT WORKS:
--   1. Mason (the plugin) INSTALLS language servers (e.g. clangd for C++)
--   2. vim.lsp.enable() STARTS them when you open a matching file
--   3. vim.lsp.config() sets capabilities (what features to request)
--   4. Keybindings are set up in the LspAttach autocmd below
--
-- ADDING A NEW LANGUAGE:
--   1. Find the server name:  :Mason  then search, or check
--      https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
--   2. Add the server name to vim.lsp.enable() list below
--   3. Add it to mason-tool-installer in lua/plugins/mason.lua
--   4. (Optional) Create a config file in lsp/<server_name>.lua for custom settings
--   5. Restart Neovim. Mason auto-installs it, then it starts working.
--
-- CUSTOM PER-SERVER CONFIG:
--   Create a file at lsp/<server_name>.lua (e.g. lsp/clangd.lua).
--   Neovim 0.12 auto-loads these files. See lsp/ts_ls.lua for an example.
--   The file should return a table with: cmd, filetypes, root_markers, settings.
-- =============================================================================


-- =============================================================================
-- STEP 1: Enable LSP servers
-- =============================================================================
-- Each name here corresponds to a language server. Neovim will start the
-- server automatically when you open a file of the matching type.
--
-- SERVER NAME          LANGUAGE(S)
-- clangd               C, C++, Objective-C
-- basedpyright         Python (type checking + intellisense)
-- gopls                Go
-- ts_ls                JavaScript, TypeScript, JSX, TSX
-- lua_ls               Lua (for editing Neovim configs!)
-- rust_analyzer        Rust
-- eslint               JavaScript/TypeScript linting
-- tailwindcss          Tailwind CSS class completions
-- html                 HTML
-- cssls                CSS
-- css_variables        CSS custom properties
-- cssmodules_ls        CSS Modules
-- dockerls             Dockerfiles
-- jsonls               JSON (with schema validation)
-- yamlls               YAML
-- bashls               Bash/Shell scripts
-- marksman             Markdown
-- taplo                TOML files
-- lemminx              XML
-- nginx_language_server Nginx config files
vim.lsp.enable({
  "clangd",           -- C / C++
  "basedpyright",     -- Python
  "gopls",            -- Go
  "ts_ls",            -- JavaScript / TypeScript
  "lua_ls",           -- Lua
  "rust_analyzer",    -- Rust
  "eslint",           -- JS/TS linting
  "tailwindcss",      -- Tailwind CSS
  "html",             -- HTML
  "cssls",            -- CSS
  "css_variables",    -- CSS custom properties
  "cssmodules_ls",    -- CSS Modules
  "dockerls",         -- Dockerfiles
  "jsonls",           -- JSON
  "yamlls",           -- YAML
  "bashls",           -- Bash
  "marksman",         -- Markdown
  "taplo",            -- TOML
  "lemminx",          -- XML
  "nginx_language_server", -- Nginx
})


-- =============================================================================
-- STEP 2: Configure diagnostics display
-- =============================================================================
-- Diagnostics are the errors, warnings, and hints that LSP servers report.
-- This controls HOW they appear in the editor.
vim.diagnostic.config({
  -- Floating window settings (shown when you press gl)
  float = {
    focusable = true,          -- you can scroll/interact with the popup
    style = "minimal",         -- no extra decorations
    border = "rounded",        -- rounded corners on the popup
    source = true,             -- show which LSP/linter produced the diagnostic
    header = "",
    prefix = "",
  },

  -- virtual_text shows error messages inline after each line.
  -- Set to false if you find them too noisy (then use gl to check manually).
  virtual_text = true,

  -- virtual_lines draws the diagnostic BELOW the line. Also disabled.
  virtual_lines = false,

  -- Signs are the icons in the gutter (left margin).
  -- These are Nerd Font icons for Error, Warn, Hint, Info.
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = " ",
      [vim.diagnostic.severity.INFO] = " ",
    },
  },

  -- Underline the problematic code
  underline = true,

  -- Don't update diagnostics while you're typing (wait until you leave insert)
  update_in_insert = false,

  -- Show errors before warnings before hints
  severity_sort = true,
})


-- =============================================================================
-- STEP 3: Inlay hints (disabled by default)
-- =============================================================================
-- Inlay hints show type information inline, like:
--   let x/* : number */ = 5
-- They can be noisy, so they're off by default.
-- Toggle with:  :lua vim.lsp.inlay_hint.enable(true)
vim.lsp.inlay_hint.enable(false)


-- =============================================================================
-- STEP 4: LSP capabilities (what features to request from servers)
-- =============================================================================
-- "Capabilities" tell the server what Neovim can handle.
-- blink.cmp adds extra completion capabilities.
local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()

-- Default config for ALL servers
vim.lsp.config("*", {
  capabilities = lsp_capabilities,
})

-- If blink.cmp loaded successfully, extend capabilities with its features
-- (better completion support, snippet support, etc.)
local blink_status_ok, blink = pcall(require, "blink.cmp")
if blink_status_ok then
  local ext_capabilities = vim.tbl_deep_extend(
    "force", {}, lsp_capabilities, blink.get_lsp_capabilities()
  )
  vim.lsp.config("*", {
    capabilities = ext_capabilities,
  })
end


-- =============================================================================
-- STEP 5: LSP keybindings (set when a server attaches to a buffer)
-- =============================================================================
-- These keybindings only activate in buffers where an LSP server is running.
-- The LspAttach event fires when a server connects to your file.
local keymap = vim.keymap
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- "opts" scoped to this buffer so keys only work in LSP-enabled files
    local opts = { buffer = ev.buf, silent = true }

    -- GO TO REFERENCES: shows all places this symbol is used
    -- Press gr -> FzfLua opens with a list of references
    -- Navigate with j/k, press Enter to jump, Esc to close
    opts.desc = "Show LSP references"
    keymap.set("n", "gr", "<cmd>FzfLua lsp_references<CR>", opts)

    -- GO TO DECLARATION: jump to where the symbol is declared
    -- (Declaration vs Definition: declaration is the prototype/interface,
    --  definition is the actual implementation. In many languages they're the same.)
    opts.desc = "Go to declaration"
    keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

    -- GO TO DEFINITION: jump to where the function/class/variable is defined
    -- This is probably the most-used LSP feature.
    -- Press gd on a function call -> jumps to the function body
    -- Use Ctrl-o to jump back to where you were
    opts.desc = "Show LSP definitions"
    keymap.set("n", "gd", "<cmd>FzfLua lsp_definitions<CR>", opts)

    -- GO TO IMPLEMENTATIONS: for interfaces/abstract classes,
    -- shows all concrete implementations
    opts.desc = "Show LSP implementations"
    keymap.set("n", "gi", "<cmd>FzfLua lsp_implementations<CR>", opts)

    -- GO TO TYPE DEFINITION: jump to the type of the variable under cursor
    -- e.g. cursor on `user` -> jumps to the User interface/struct
    opts.desc = "Show LSP type definitions"
    keymap.set("n", "gt", "<cmd>FzfLua lsp_typedefs<CR>", opts)

    -- CODE ACTIONS: shows available automatic fixes
    -- e.g. "Add missing import", "Remove unused variable", "Extract function"
    -- Press Space ca -> popup menu of available actions -> Enter to apply
    opts.desc = "See available code actions"
    keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

    -- RENAME SYMBOL: rename a variable/function everywhere it's used
    -- Press Space lr -> type new name -> Enter
    -- This is WAY better than find-and-replace because it understands scope
    opts.desc = "Smart rename"
    keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)

    -- BUFFER DIAGNOSTICS: show all errors/warnings in the current file
    opts.desc = "Show buffer diagnostics"
    keymap.set("n", "<leader>D", "<cmd>FzfLua diagnostics_document<CR>", opts)

    -- LINE DIAGNOSTICS: show the error/warning on the current line
    -- Press gl -> floating popup with full diagnostic message
    -- Press q or Esc to dismiss the popup
    opts.desc = "Show line diagnostics"
    keymap.set("n", "gl", vim.diagnostic.open_float, opts)

    -- NAVIGATE DIAGNOSTICS: jump between errors/warnings
    -- Space dk = jump to PREVIOUS diagnostic
    -- Space dj = jump to NEXT diagnostic
    opts.desc = "Go to previous diagnostic"
    keymap.set("n", "<leader>dk", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, opts)

    opts.desc = "Go to next diagnostic"
    keymap.set("n", "<leader>dj", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, opts)

    -- HOVER DOCUMENTATION:
    -- Press K (capital k) on any symbol to see its documentation.
    -- This is a BUILT-IN default in Neovim 0.12, no mapping needed.
    -- Press K again or move cursor to dismiss the hover popup.
    -- You can scroll inside the popup with Ctrl-d / Ctrl-u.
  end,
})
