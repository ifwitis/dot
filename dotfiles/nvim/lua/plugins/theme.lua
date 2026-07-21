return {
    -- Theme Installation
    { "folke/tokyonight.nvim", lazy = false, priority = 1000 },
    { "catppuccin/nvim", lazy = false, priority = 1000 },
    { "EdenEast/nightfox.nvim", lazy = false, priority = 1000 },
    { "sainnhe/everforest", lazy = false, priority = 1000 },
    { "zenbones-theme/zenbones.nvim", lazy = false, priority = 1000 },

    -- Theme Manager
    {
        "zaldih/themery.nvim",
        lazy = false,
        config = function()
            require("themery").setup({
                themes = { 
                -- Dark Themes
                    {
                        name = "Tokyo Storm",
                        colorscheme = "tokyonight-storm",
                    },
                    {
                        name = "Tokyo Moon",
                        colorscheme = "tokyonight-moon",
                    },
                    {
                        name = "Catppuccin Dark Mocha",
                        colorscheme = "catppuccin-mocha",
                    }, 
                    {
                        name = "Catppuccin Light Frappe",
                        colorscheme = "catppuccin-frappe",
                    },
                    {
                        name = "Carbonfox",
                        colorscheme = "carbonfox",
                    },
                    {
                        name = "Nightfox",
                        colorscheme = "nightfox",
                    }, 
                    {
                        name = "Nordfox",
                        colorscheme = "nordfox",
                    },
                    {
                        name = "Evergreen",
                        colorscheme = "everforest",
                        before = [[
                            vim.o.background = "dark"
                            vim.g.everforest_background = "hard"
                        ]],
                    },

                -- Contrast Themes
                    {
                        name = "Zenbones Dark",
                        colorscheme = "zenbones",
                        before = [[
                            vim.o.background = "dark"
                            vim.g.zenbones_compat = 1
                            vim.g.forestbones = { darkness = 'default' }
                        ]],
                    },
                    {
                        name = "Zenbones Light",
                        colorscheme = "zenbones",
                        before = [[
                            vim.o.background = "light"
                            vim.g.zenbones_compat = 1
                            vim.g.forestbones = { lightness = 'dim' }
                        ]],
                    },


                -- Light Themes
                    {
                        name = "Dawnfox",
                        colorscheme = "dawnfox",
                    },
                    {
                        name = "Dayfox",
                        colorscheme = "dayfox",
                    },
                    {
                        name = "Tokyo Day",
                        colorscheme = "tokyonight-day"
                    },
                    {
                        name = "Everlight",
                        colorscheme = "everforest",
                        before = [[
                            vim.o.background = "light"
                            vim.g.everforest_background = "soft"
                        ]], 
                    }
                },
                livePreview = true,
            })
        end
    }
}
