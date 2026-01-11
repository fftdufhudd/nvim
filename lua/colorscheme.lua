local M = {
    "rose-pine/nvim",
    lazy = false, -- Loads this plugin at the beginning
    priority = 1000, 
}

function M.config()
	vim.cmd.colorscheme "rose-pine"
end

return M
