local M = {
   'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    -- Optional: for live grep and file searching on huge projects
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make', -- Compilation step for fzf-native
  }
}

return M
