-- =============================================================================
-- pack.lua  (Plugin Manager)
-- =============================================================================
--
-- This file uses vim.pack, a BUILT-IN plugin manager in Neovim 0.12+.
-- No need to install lazy.nvim or packer.nvim separately!
--
-- HOW IT WORKS:
--   vim.pack.add({ "https://github.com/user/plugin.git", ... })
--   - Downloads plugins from GitHub automatically on first launch
--   - Updates them when you run :PackUpdate
--
-- OPTIONS:
--   src = "url"         -- explicit URL (instead of bare string)
--   version = "1.x"     -- pin to a version range or specific commit
--
-- AFTER ADDING A PLUGIN:
--   1. Add its URL here in vim.pack.add()
--   2. Create a config file in lua/plugins/  (e.g. lua/plugins/my-plugin.lua)
--   3. Restart Neovim. vim.pack auto-installs missing plugins.
--
-- TO REMOVE A PLUGIN:
--   1. Delete its URL from this file
--   2. Delete its config file from lua/plugins/
--   3. Run :lua vim.pack.del({"plugin-name"}) to clean up installed files
-- =============================================================================

-- PackChanged hooks run AFTER a plugin is installed or updated.
-- Must be defined BEFORE vim.pack.add() so they're ready.
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind

    -- After treesitter is installed/updated, compile all parsers
    if name == "nvim-treesitter" and (kind == "install" or kind == "update") then
      if not ev.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    end
  end,
})


-- =============================================================================
-- THE PLUGIN LIST
-- =============================================================================
-- Each entry is a GitHub URL. Plugins are grouped by purpose.
-- The order doesn't matter here (loading order is handled by Neovim).
vim.pack.add({
  -- CORE UI
  -- Catppuccin: warm pastel colorscheme (4 flavours: mocha, macchiato, frappe, latte)
  "https://github.com/catppuccin/nvim",
  -- snacks.nvim: collection of small UI improvements (we use indent guides)
  "https://github.com/folke/snacks.nvim",
  -- which-key: shows a popup of available keybindings when you press a prefix
  "https://github.com/folke/which-key.nvim",
  -- File type icons (used by neo-tree, fzf-lua, statusline, etc.)
  "https://github.com/nvim-tree/nvim-web-devicons",

  -- COMPLETION & LSP TOOLS
  -- blink.cmp: fast completion engine (shows suggestions as you type)
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.x") },
  -- Pre-built snippets for many languages (if/else, for loops, etc.)
  "https://github.com/rafamadriz/friendly-snippets",
  -- Copilot integration for the completion menu
  "https://github.com/giuxtaposition/blink-cmp-copilot",
  -- Mason: installs LSP servers, formatters, and linters for you
  "https://github.com/williamboman/mason.nvim",
  -- Auto-install a list of tools via Mason
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
  -- Default LSP configs (cmd, filetypes, root_markers) for ~350 servers.
  -- Your lsp/<name>.lua files override these when present.
  "https://github.com/neovim/nvim-lspconfig",
  -- Bridge between Mason and Neovim's built-in LSP
  "https://github.com/mason-org/mason-lspconfig.nvim",

  -- TREESITTER (syntax highlighting & code understanding)
  "https://github.com/nvim-treesitter/nvim-treesitter",

  -- EDITOR FEATURES
  -- Context-aware commenting for JSX/TSX (knows // vs {/* */})
  "https://github.com/folke/ts-comments.nvim",
  -- Auto-close brackets, quotes, parentheses
  "https://github.com/windwp/nvim-autopairs",
  -- Smooth scrolling animations
  { src = "https://github.com/karb94/neoscroll.nvim", version = "e786577" },
  -- Highlight unique characters on f/F/t/T motions for quick jumping
  "https://github.com/jinh0/eyeliner.nvim",

  -- NAVIGATION & FILES
  -- Fuzzy finder: search files, text, git history, and everything else
  "https://github.com/ibhagwan/fzf-lua",
  -- File tree sidebar
  "https://github.com/nvim-neo-tree/neo-tree.nvim",
  -- Lua utility library (dependency for many plugins)
  "https://github.com/nvim-lua/plenary.nvim",
  -- UI component library (dependency for neo-tree)
  "https://github.com/MunifTanjim/nui.nvim",
  -- Edit your filesystem like a buffer (rename files by editing text!)
  "https://github.com/stevearc/oil.nvim",
  -- Auto-detect project root directory
  "https://github.com/ahmedkhalf/project.nvim",
  -- Quick file bookmarks (mark files you jump to often)
  { src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },

  -- GIT
  -- Show git diff signs in the gutter (added/changed/deleted lines)
  "https://github.com/lewis6991/gitsigns.nvim",

  -- FORMATTING & LINTING
  -- conform.nvim: run formatters (prettier, clang-format, black, etc.)
  "https://github.com/stevearc/conform.nvim",
  -- nvim-lint: run linters (eslint, pylint, cpplint, etc.)
  "https://github.com/mfussenegger/nvim-lint",

  -- BREADCRUMBS (shows File > Class > Function in the winbar)
  "https://github.com/SmiteshP/nvim-navic",
  "https://github.com/LunarVim/breadcrumbs.nvim",

  -- AI & TOOLS
  -- GitHub Copilot (AI code suggestions)
  "https://github.com/zbirenbaum/copilot.lua",
  -- Better quickfix list UI
  "https://github.com/kevinhwang91/nvim-bqf",
  -- Preview CSS/Tailwind colors inline
  "https://github.com/catgoose/nvim-colorizer.lua",

  -- CPP COMPETITIVE PROGRAMMING
  -- Jellybeans colorscheme (matches MacVim setup)
  "https://github.com/nanotech/jellybeans.vim",
  -- Vague colorscheme (sylvan's theme — muted earthy palette, matches ghostty)
  "https://github.com/vague2k/vague.nvim",
  -- UltiSnips: snippet engine used by the pastebin cpp.snippets file
  -- (requires pynvim: pip3 install --user --break-system-packages pynvim)
  "https://github.com/sirver/ultisnips",
})


-- =============================================================================
-- AUTO-LOAD PLUGIN CONFIGS
-- =============================================================================
-- This loop finds every .lua file in lua/plugins/ and requires it.
-- So if you create lua/plugins/foo.lua, it gets loaded automatically.
-- You don't need to add a require() call anywhere.
local config_path = vim.fn.stdpath("config") .. "/lua/plugins"
for _, file in ipairs(vim.fn.glob(config_path .. "/*.lua", false, true)) do
  -- Convert file path to Lua module path:
  --   /path/to/lua/plugins/foo.lua  -->  plugins.foo
  local module = file:match("lua/(.+)%.lua$"):gsub("/", ".")
  local ok, err = pcall(require, module)
  if not ok then
    vim.notify("Error loading " .. module .. ": " .. err, vim.log.levels.WARN)
  end
end
