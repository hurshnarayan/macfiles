-- =============================================================================
-- ultisnips.lua  (Snippet engine for C++ competitive programming)
-- =============================================================================
-- UltiSnips expands snippet triggers → code templates.
-- Loads snippets from ~/.vim/UltiSnips/ (the pastebin cpp.snippets lives there).
--
-- REQUIRES pynvim. If snippets don't expand, run:
--   pip3 install --user --break-system-packages pynvim
-- Then restart nvim and run  :checkhealth provider.python  to verify.
--
-- TRIGGERS (matches MacVim muscle memory):
--   <Tab>      expand snippet / jump to next placeholder
--   <S-Tab>    jump to previous placeholder
--
-- blink.cmp's <Tab> handler (in lua/plugins/blink.lua) checks UltiSnips
-- first: if a snippet is expandable/jumpable, UltiSnips fires; otherwise
-- blink.cmp's normal Tab behavior runs.
-- =============================================================================

-- Where UltiSnips looks for .snippets files.
-- "UltiSnips" is relative — UltiSnips finds it in every &runtimepath entry,
-- which includes ~/.config/nvim. So cpp.snippets lives in your committed
-- nvim config, independent of the MacVim copy at ~/.vim/UltiSnips/.
vim.g.UltiSnipsSnippetDirectories = { "UltiSnips" }

-- Neutralize UltiSnips' own Tab binding so blink.cmp owns the key.
-- Expand and forward-jump share the same <Plug> so "Tab" means
-- "expand if possible, else jump forward" — UltiSnips handles both.
vim.g.UltiSnipsExpandTrigger       = "<Plug>(ultisnips_expand)"
vim.g.UltiSnipsJumpForwardTrigger  = "<Plug>(ultisnips_expand)"
vim.g.UltiSnipsJumpBackwardTrigger = "<Plug>(ultisnips_jump_backward)"
