return {
    "akinsho/bufferline.nvim",
    dependencies = 'nvim-tree/nvim-web-devicons',
    lazy = false,
    priority = 500,
    config = function()
        require("bufferline").setup({
            options = {
                mode = "buffers",
                separator_style = "thin",
                numbers = "ordinal",
                show_buffer_close_icons = false,
                show_close_icon = false,
                always_show_bufferline = true,
            }
        })
    end,
}
