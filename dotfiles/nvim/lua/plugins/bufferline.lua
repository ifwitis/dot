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
        vim.api.nvim_create_autocmd("VimEnter", {
            once = true,
            callback = function()
                vim.schedule(function()
                    local themery = require("themery")
                    local current = themery.getCurrentTheme()

                    if current then
                        themery.setThemeByName(current.name, false)
                    end
                end)
            end,
        })
    end,
}
