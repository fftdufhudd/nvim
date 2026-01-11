vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>q", vim.cmd.q)
vim.keymap.set("n", "<leader>t", vim.cmd.terminal)

local function set_cwd_to_explorer_root()
    -- Get the filetype of the current buffer
    local ft = vim.bo.filetype
    
    -- Check for common file explorer filetypes: Netrw (dirbuf, netrw) or NvimTree
    if ft == 'dirbuf' or ft == 'netrw' or ft == 'NvimTree' then
        -- Get the full path of the current buffer (which is the directory path)
        local dir_path = vim.fn.expand('%')
        
        -- Change the CWD to that path
        vim.cmd.cd(dir_path)
        print("CWD changed to: " .. dir_path)
    else
        print("Not a directory view buffer.")
    end
end

-- Keymap Example: <leader>ce (Change Explorer)
-- This binding will change the CWD to the folder you are currently listing.
vim.keymap.set('n', '<leader>ce', set_cwd_to_explorer_root, { desc = 'Change CWD to Explorer Root' })
vim.keymap.set('t', '<ESC>', [[<C-\><C-n>]], { noremap = true })
