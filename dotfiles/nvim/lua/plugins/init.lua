return {
    {
        "folke/tokyonight.nvim", -- or any colorscheme you like
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme tokyonight]])
        end,
    },
}

