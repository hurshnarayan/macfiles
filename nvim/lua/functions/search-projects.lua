-- =============================================================================
-- search-projects.lua  (Project Switcher)
-- =============================================================================
--
-- Uses project.nvim's history to let you quickly switch between recent projects.
--
-- SHORTCUT:
--   Space fp  = open project switcher
--   :Projects = same thing as a command
--
-- When you select a project, it:
--   1. Changes directory to the project root
--   2. Closes all current buffers
--   3. Opens the file explorer
-- =============================================================================

local function search_projects()
  local history = require("project_nvim.utils.history")
  local recent_projects = history.get_recent_projects()

  local entries = {}
  for _, project_path in ipairs(recent_projects) do
    local project_name = vim.fn.fnamemodify(project_path, ":t")
    table.insert(entries, string.format("%-30s %s", project_name, project_path))
  end

  require("fzf-lua").fzf_exec(entries, {
    prompt = "Projects> ",
    actions = {
      ["default"] = function(selected)
        if selected and #selected > 0 then
          local path = selected[1]:match("%s+(.+)$")
          vim.cmd("cd " .. path)
          vim.cmd("bufdo bd")
          vim.cmd("Neotree reveal")
        end
      end,
    },
  })
end

vim.api.nvim_create_user_command("Projects", search_projects, {})
vim.keymap.set("n", "<leader>fp", search_projects, { desc = "Find projects" })
