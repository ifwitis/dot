return {
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            -- Nvim Tree Setup
            require("nvim-tree").setup({
                update_cwd = true, -- update the root directory to cwd of opened buffer
                respect_buf_cwd = true, -- respest buffer's current working directory
                renderer = {
                    highlight_git = true,
                },
                hijack_directories = {
                    enable = false,
                },
                view = {
                    side = "left",
                    width = 20,
                    preserve_window_proportions = true,
                },
                update_focused_file = {
                    enable = true,
                    update_cwd = true,
                },
                actions = {
                    open_file = {
                        resize_window = true,
                        window_picker = {
                            enable = true,
                            chars = "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ",
                        },
                    },
                },

            })
        end,
    },

    {
        "folke/tokyonight.nvim", -- or any colorscheme you like
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme tokyonight]])
        end,
    },
}

