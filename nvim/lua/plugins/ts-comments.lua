-- =============================================================================
-- ts-comments.lua  (Context-Aware Commenting)
-- =============================================================================
--
-- Enhances Neovim's built-in gc/gcc commenting to be context-aware.
-- In JSX/TSX files, it knows to use {/* */} inside JSX and // outside.
-- Without this plugin, commenting in JSX would use the wrong syntax.
-- =============================================================================

require("ts-comments").setup()
