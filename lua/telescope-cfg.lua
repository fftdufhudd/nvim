local telescope = require('telescope')
local builtin = require('telescope.builtin')

-- Load the fzf-native extension for better performance
telescope.load_extension('fzf')

telescope.setup {
  defaults = {
    -- Default settings for all pickers
    -- For example, setting the border to be slightly rounded:
    border = true,
    sorting_strategy = "ascending",
    --layout_config = {
    --    width = 0.8,
    --    preview_height = 0.6,
    --    horizontal = {
    --        preview_width = 0.6,
    --    },
    --},
  },
  extensions = {
    fzf = {
      -- This is the table for fzf-native settings
      fuzzy = true,
      override_file_set = true,
      override_generic_sorter = true,
    }
  }
}

-- Keymaps (Recommended)
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find Files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live Grep (Search Content)' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find Buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Find Help Tags' })
vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = 'Find Keymaps' })
