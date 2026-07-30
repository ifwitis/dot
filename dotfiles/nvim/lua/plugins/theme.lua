return {
    -- Theme Installation
    { "folke/tokyonight.nvim",          lazy = false, priority = 1000 },
    { "catppuccin/nvim", name = 'catppuccin', lazy = false, priority = 1000 },
    { "EdenEast/nightfox.nvim",         lazy = false, priority = 1000 },
    { "everviolet/nvim", name = 'evergarden', lazy = false, priority = 1000 },
    { "sainnhe/everforest",             lazy = false, priority = 1000 },
    { "zenbones-theme/zenbones.nvim",   lazy = false, priority = 1000 },
    { "stevedylandev/compline-nvim",    lazy = false, priority = 1000 },

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
                        name = "Compline",
                        colorscheme = "compline",
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
                    {
                        name = "Evergarden Spring",
                        colorscheme = "evergarden",
                        before = [[
                            require("evergarden").setup({
                                theme = {
                                    variant = "spring",
                                    accent = "green",
                                },
                            })
                        ]],
                    },
                    {
                        name = "Evergarden Summer",
                        colorscheme = "evergarden",
                        before = [[
                            require("evergarden").setup({
                                theme = {
                                    variant = "summer",
                                    accent = "green",
                                },
                            })
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

                    -- Transparent Theme
                    {
                        name = "Transparent 0",
                        colorscheme = "catppuccin-mocha",
                        before = [[
                            require("catppuccin").setup({
                                transparent_background = true,
                                float = {
                                    transparent = true,
                                },
                            })
                        ]]
                    },
                    {
                        name = "Transparent 1",
                        colorscheme = "evergarden",
                        before = [[
                            require("evergarden").setup({
                                theme = {
                                    variant = "spring",
                                    accent = "green",
                                },
                                editor = {
                                    transparent_background = true,
                                    override_terminal = true,
                                    float = {
                                        color = "mantle",
                                        solid_border = false,
                                    },
                                },
                            })
                        ]]
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
                        colorscheme = "tokyonight-day",
                    },
                    {
                        name = "Everlight",
                        colorscheme = "everforest",
                        before = [[
                        vim.o.background = "light"
                        vim.g.everforest_background = "soft"
                        ]],
                    },
                },
                livePreview = true,
            })
        end,
    },
}
