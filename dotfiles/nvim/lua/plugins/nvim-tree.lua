return {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function() 
        vim.cmd([[hi NvimTreeNormal guibg=NONE ctermbg=NONE]])
        require("nvim-tree").setup({
            filters = {
                dotfiles = false, -- Show hidden files (dotfiles)
            },
            view = {
                adaptive_size = true,
            },
            update_focused_file = {
                enable = true,
                update_root = false,
            },
        })
    end 
}
