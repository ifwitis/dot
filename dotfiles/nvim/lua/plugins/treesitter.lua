return {
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            'neovim-treesitter/treesitter-parser-registry',
        },
        -- branch = "master",
        build = ":TSUpdate",
        opts = {},
    }
}
