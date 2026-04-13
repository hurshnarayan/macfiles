-- =============================================================================
-- lsp/tailwindcss.lua  (Tailwind CSS Language Server Config)
-- =============================================================================
--
-- Provides Tailwind CSS class completions, hover previews, and linting.
-- Only activates in projects that have a tailwind.config.* file.
-- =============================================================================

return {
  cmd = { "tailwindcss-language-server", "--stdio" },
  filetypes = {
    "html", "css", "scss",
    "javascript", "javascriptreact",
    "typescript", "typescriptreact",
    "svelte",
  },
  root_markers = {
    "tailwind.config.js", "tailwind.config.ts",
    "tailwind.config.mjs", "tailwind.config.cjs",
    "postcss.config.js", "postcss.config.ts",
    "package.json",
  },
  settings = {
    tailwindCSS = {
      classAttributes = { "class", "className", "class:list", "classList", "ngClass" },
      validate = true,
    },
  },
}
