return {
    "neovim/nvim-lspconfig",
    dependencies = {
        {
            "mason-org/mason.nvim",
            opts = {
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    }
                },

            }
        },                                           -- lsp/dap/linter installer & manager
        { "mason-org/mason-lspconfig.nvim", opts = {} }, -- automatic package name translation for mason
        'whoissethdaniel/mason-tool-installer.nvim', -- automatic installer for mason
        "creativenull/efmls-configs-nvim",           -- preconfigured efm language server setups
    },
    config = function()
        require("utils.diagnostics").setup()
        require("lsp")
    end,
}
