-- =============================================================================
-- lsp/clangd.lua  (C / C++ Language Server Config)
-- =============================================================================
--
-- clangd is the C/C++ language server from the LLVM project.
-- It provides completions, go-to-definition, diagnostics, and more.
--
-- IMPORTANT: clangd needs a compile_commands.json or .clangd file to
-- understand your project's build settings. Generate it with:
--
--   CMake:    cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ..
--   Make:     bear -- make        (install bear: brew install bear)
--   Manual:   create a .clangd file in your project root
--
-- Example .clangd file:
--   CompileFlags:
--     Add: [-std=c++17, -Wall]
-- =============================================================================

return {
  cmd = {
    "clangd",
    "--background-index",        -- index project in background
    "--clang-tidy",              -- enable clang-tidy linting
    "--header-insertion=iwyu",   -- auto-add missing #include
    "--completion-style=detailed", -- show full signature in completions
    "--function-arg-placeholders", -- show parameter placeholders
    "--fallback-style=llvm",     -- formatting style when no .clang-format
  },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
  root_markers = {
    ".clangd",
    ".clang-tidy",
    ".clang-format",
    "compile_commands.json",
    "compile_flags.txt",
    "configure.ac",
    ".git",
  },
  -- clangd-specific capabilities: tell it we support UTF-16 offsets
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
  },
}
