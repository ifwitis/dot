return {
  "neovim/nvim-lspconfig",
  dependencies = {
    {
      "mason-org/mason.nvim",
      keys = {
        { "<leader>m", "<cmd>Mason<CR>", desc = "Open Mason" },
      },
      opts = {
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          }
        },

      }
    },                                    -- lsp/dap/linter installer & manager
    { "mason-org/mason-lspconfig.nvim" },     -- automatic package name translation for mason
  },
  config = function()
    require("lsp")
  end,
}
