return {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = function()
        require("nvim-autopairs").setup({
            map_cr = false,
            check_ts = true, -- Enable Treesitter integration to prevent pairing inside comments/strings
            disable_filetype = { "TelescopePrompt", "spectre_panel" },
        })
    end
}
