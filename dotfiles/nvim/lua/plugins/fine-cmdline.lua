return {
    'VonHeikemen/fine-cmdline.nvim',
    dependencies = {
        { 'MunifTanjim/nui.nvim' }
    },
    opts = {
        popup = {
            position = {
                row = '50%',
                col = '50%',
            },
            size = {
                width = '50%',
            },

            -- style = {
            --     top_left    = "╭", top    = "─",    top_right = "╮",
            --     left        = "│",                      right = "│",
            --     bottom_left = "╰", bottom = "─", bottom_right = "╯",
            -- },
        },
    }
}
