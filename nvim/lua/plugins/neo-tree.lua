-- =============================================================================
-- neo-tree.lua  (File Explorer Sidebar)
-- =============================================================================
--
-- Neo-tree is the file tree on the left side (like VS Code's sidebar).
--
-- HOW TO USE:
--   Space e     = toggle the file tree open/closed
--
-- INSIDE NEO-TREE:
--   l / Enter   = open file or expand folder
--   h           = collapse folder
--   s           = open in vertical split
--   t           = open in new tab
--   a           = create new file (type the name, include / for directories)
--   A           = create new directory
--   d           = delete file/folder
--   r           = rename
--   y           = copy to clipboard
--   x           = cut
--   c           = copy file
--   m           = move file
--   q           = close neo-tree
--   R           = refresh the tree
--   ?           = show help with all keybindings
--   < / >       = switch between Files / Buffers / Git views
--   i           = show file details (size, modified date)
-- =============================================================================

-- Toggle the file explorer with Space e
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle file explorer" })

-- Disable the built-in file browser (netrw) since we're using neo-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("neo-tree").setup({
  close_if_last_window = false,  -- don't quit Neovim if neo-tree is the last window
  popup_border_style = "rounded",
  enable_git_status = true,      -- show git status icons next to files
  enable_diagnostics = true,     -- show LSP error/warning counts

  -- Tab bar at the top of neo-tree: switch between views
  source_selector = {
    sources = {
      { source = "filesystem", display_name = " \u{f024b} Files " },
      { source = "buffers", display_name = " \u{f0214} Buffers " },
      { source = "git_status", display_name = " \u{f02a2} Git " },
    },
  },

  default_component_configs = {
    indent = {
      indent_size = 2,
      padding = 1,
      with_markers = true,
      indent_marker = "\u{2502}",
      last_indent_marker = "\u{2514}",
      expander_collapsed = "\u{e602}",
      expander_expanded = "\u{e604}",
    },
    icon = {},
    modified = {},
    name = {
      trailing_slash = false,
      use_git_status_colors = true,
    },
    git_status = {
      symbols = {
        added = "",
        modified = "",
        deleted = "\u{2716}",
        renamed = "\u{f0455}",
      },
    },
    file_size = { enabled = true, required_width = 64 },
    type = { enabled = true, required_width = 122 },
    last_modified = { enabled = true, required_width = 88 },
    created = { enabled = true, required_width = 110 },
    symlink_target = { enabled = false },
  },

  -- Window settings
  window = {
    position = "left",
    width = 35,
    mappings = {
      ["l"] = "open",
      ["h"] = "close_node",
      ["s"] = "open_vsplit",
      ["S"] = "",
      ["t"] = "open_tabnew",
      ["w"] = "open_with_window_picker",
      ["C"] = "close_node",
      ["z"] = "close_all_nodes",
      ["a"] = { "add", config = { show_path = "none" } },
      ["A"] = "add_directory",
      ["d"] = "delete",
      ["r"] = "rename",
      ["y"] = "copy_to_clipboard",
      ["x"] = "cut_to_clipboard",
      ["c"] = "copy",
      ["m"] = "move",
      ["q"] = "close_window",
      ["R"] = "refresh",
      ["?"] = "show_help",
      ["<"] = "prev_source",
      [">"] = "next_source",
      ["i"] = "show_file_details",
    },
  },

  -- Filesystem settings
  filesystem = {
    bind_to_cwd = true,
    cwd_target = { sidebar = "tab", current = "window" },
    filtered_items = {
      visible = true,          -- show filtered items as dimmed
      hide_dotfiles = false,   -- show .dotfiles
      hide_gitignored = false, -- show .gitignored files
      hide_hidden = false,
      always_show = { ".gitignore" },
      never_show = { ".DS_Store" },
    },
    follow_current_file = {
      enabled = true,          -- auto-highlight the file you're editing
      leave_dirs_open = false,
    },
    hijack_netrw_behavior = "open_default",
    use_libuv_file_watcher = true,  -- auto-refresh when files change on disk
  },

  -- Buffers view settings
  buffers = {
    follow_current_file = { enabled = true, leave_dirs_open = false },
    group_empty_dirs = true,
    show_unloaded = true,
    window = {
      mappings = { ["dd"] = "buffer_delete" },
    },
  },
})
