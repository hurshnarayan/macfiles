-- =============================================================================
-- fzf-lua.lua  (Fuzzy Finder)
-- =============================================================================
--
-- fzf-lua is the "search everything" tool. It uses fzf (a fast fuzzy finder)
-- to search files, text, git history, keymaps, help pages, and more.
--
-- HOW TO USE:
--   1. Press a shortcut (e.g. Space ff to find files)
--   2. A popup opens with a search bar and preview
--   3. Type to fuzzy-filter results
--   4. Navigate with Ctrl+j (down) / Ctrl+k (up)
--   5. Press Enter to open the selected result
--   6. Press Esc to close without selecting
--
-- INSIDE THE FZF WINDOW:
--   Ctrl+j / Ctrl+k  = navigate results
--   Enter            = open in current window
--   Ctrl+v           = open in vertical split
--   Ctrl+s           = open in horizontal split
--   Ctrl+t           = open in new tab
--   Tab              = toggle selection (for multi-select)
-- =============================================================================

local fzf = require("fzf-lua")

fzf.setup({
  winopts = {
    height = 0.85,     -- popup takes 85% of screen height
    width = 0.80,      -- popup takes 80% of screen width
    row = 0.35,        -- vertical position (0 = top, 1 = bottom)
    col = 0.50,        -- horizontal position (centered)
    border = "rounded",
    preview = {
      border = "border",
      wrap = "nowrap",
      hidden = "nohidden",      -- show preview by default
      vertical = "down:45%",    -- preview below in vertical layout
      horizontal = "right:50%", -- preview right in horizontal layout
      layout = "flex",          -- auto-choose based on terminal size
      flip_columns = 120,       -- switch to vertical if < 120 columns
      title = true,
      scrollbar = "float",
      delay = 100,
    },
  },
  fzf_opts = {
    ["--layout"] = "reverse",   -- results at top, prompt at bottom
    ["--info"] = "inline",
    ["--bind"] = "ctrl-j:down,ctrl-k:up",
  },
})

local map = vim.keymap.set


-- =============================================================================
-- FILE SEARCH shortcuts (Space f...)
-- =============================================================================

-- Find files by name in the current project
map("n", "<leader>ff", "<cmd>FzfLua files<cr>", { desc = "Find Files" })

-- Recently opened files
map("n", "<leader>fr", "<cmd>FzfLua oldfiles<cr>", { desc = "Recent Files" })

-- Switch between open buffers
map("n", "<leader>fb", "<cmd>FzfLua buffers<cr>", { desc = "Buffers" })

-- Find files in your Neovim config directory
map("n", "<leader>fc", function()
  fzf.files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Find Config File" })

-- Find files tracked by git
map("n", "<leader>fg", "<cmd>FzfLua git_files<cr>", { desc = "Find Git Files" })


-- =============================================================================
-- TEXT SEARCH shortcuts (Space f...)
-- =============================================================================

-- Live grep: search text across all files (updates as you type)
map("n", "<leader>ft", "<cmd>FzfLua live_grep<cr>", { desc = "Live Grep" })

-- Search for the word under your cursor across all files
map("n", "<leader>fw", "<cmd>FzfLua grep_cword<cr>", { desc = "Grep Word Under Cursor" })

-- Search for visually selected text across all files
map("v", "<leader>fw", "<cmd>FzfLua grep_visual<cr>", { desc = "Grep Visual Selection" })

-- Search lines in the current buffer
map("n", "<leader>fl", "<cmd>FzfLua blines<cr>", { desc = "Buffer Lines" })

-- Search lines across ALL open buffers
map("n", "<leader>fL", "<cmd>FzfLua lines<cr>", { desc = "Lines (All Buffers)" })


-- =============================================================================
-- GIT shortcuts (Space g...)
-- =============================================================================

-- See which files have uncommitted changes
map("n", "<leader>gs", "<cmd>FzfLua git_status<cr>", { desc = "Git Status" })

-- Browse and switch git branches
map("n", "<leader>gb", "<cmd>FzfLua git_branches<cr>", { desc = "Git Branches" })

-- Browse commit history (git log)
map("n", "<leader>gl", "<cmd>FzfLua git_commits<cr>", { desc = "Git Log" })

-- Browse commits for the current file only
map("n", "<leader>gf", "<cmd>FzfLua git_bcommits<cr>", { desc = "Git Log File" })

-- Browse git stashes
map("n", "<leader>gS", "<cmd>FzfLua git_stash<cr>", { desc = "Git Stash" })


-- =============================================================================
-- UTILITY shortcuts (Space f...)
-- =============================================================================

map("n", "<leader>fh", "<cmd>FzfLua help_tags<cr>", { desc = "Help Pages" })
map("n", "<leader>fk", "<cmd>FzfLua keymaps<cr>", { desc = "Keymaps" })
map("n", "<leader>fH", "<cmd>FzfLua highlights<cr>", { desc = "Highlights" })
map("n", "<leader>fR", "<cmd>FzfLua resume<cr>", { desc = "Resume" })
map("n", '<leader>f"', "<cmd>FzfLua registers<cr>", { desc = "Registers" })
map("n", "<leader>fa", "<cmd>FzfLua autocmds<cr>", { desc = "Autocmds" })
map("n", "<leader>f/", "<cmd>FzfLua search_history<cr>", { desc = "Search History" })
map("n", "<leader>:", "<cmd>FzfLua command_history<cr>", { desc = "Command History" })
map("n", "<leader>fM", "<cmd>FzfLua man_pages<cr>", { desc = "Man Pages" })
map("n", "<leader>fq", "<cmd>FzfLua quickfix<cr>", { desc = "Quickfix List" })
map("n", "<leader>fj", "<cmd>FzfLua jumps<cr>", { desc = "Jumps" })
map("n", "<leader>uC", "<cmd>FzfLua colorschemes<cr>", { desc = "Colorschemes" })


-- =============================================================================
-- DIAGNOSTICS shortcuts (Space f...)
-- =============================================================================

-- All diagnostics in the current file
map("n", "<leader>fd", "<cmd>FzfLua diagnostics_document<cr>", { desc = "Buffer Diagnostics" })

-- All diagnostics across the entire workspace
map("n", "<leader>fD", "<cmd>FzfLua diagnostics_workspace<cr>", { desc = "Workspace Diagnostics" })


-- =============================================================================
-- BUFFER shortcuts (Space b...)
-- =============================================================================

-- Close/delete the current buffer
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete Buffer" })
