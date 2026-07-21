return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },  -- LSP/DAP/Linter installer & manager
        { "mason-org/mason-lspconfig.nvim", opts = {} },-- Automatic package name translation for Mason
        'WhoIsSethDaniel/mason-tool-installer.nvim',    -- Automatic installer for Mason
		"creativenull/efmls-configs-nvim",      -- Preconfigured EFM Language Server setups
	},
	config = function()
		require("utils.diagnostics").setup()
		require("lsp")
	end,
}
