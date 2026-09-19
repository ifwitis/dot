return {
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            'neovim-treesitter/treesitter-parser-registry',
        },
        lazy = false,
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("nvim-treesitter.config").setup {
                ensure_installed = {
                    "latex",
                    "lua",
                    "vim",
                    "vimdoc",
                },
                sync_install = false,
                auto_install = false,
                highlight = {
                    enable = true,
                    disable = { "latex" },
                },
                indent = {
                    enable = true,
                    disable = { "latex" },
                }, }
        end
    }
}
