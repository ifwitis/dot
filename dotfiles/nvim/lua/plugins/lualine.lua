return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }, -- Adds file icons
    config = function()
        require('lualine').setup({
            options = {
                theme = 'auto', -- Automatically matches your colorscheme
                icons_enabled = true,
            }
        })
    end
}
