return {
  "stevearc/conform.nvim",
  cmd = "ConformInfo",
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
    },
    default_format_opts = {
      lsp_format = "fallback",
    },
  },
  keys = {
    {
      "<leader>df",
      function()
        require("conform").format({ async = true })
      end,
      mode = { "n", "x" },
      desc = "Format document or selection",
    },
  },
}
