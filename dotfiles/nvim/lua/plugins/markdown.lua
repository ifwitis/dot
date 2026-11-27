return {
  {
    "brianhuster/live-preview.nvim",
    ft = { "markdown", "html", "svg" },
    cmd = { "LivePreview" },
    keys = {
      { "<leader>ps", "<cmd>LivePreview start<CR>", desc = "Start LivePreview" },
      { "<leader>pc", "<cmd>LivePreview close<CR>", desc = "Close LivePreview" },
    },
    opts = {},
  },
  {
    "OXY2DEV/markview.nvim",
    ft = { 'markdown' },
    config = function()
      local presets = require("markview.presets")
      require("markview").setup({
        modes = { "n", "no", "c" },
        hybrid_modes = { "n" },
        markdown = {
          tables = presets.tables.rounded,
          horizontal_rules = presets.horizontal_rules.arrowed,
          headings = presets.headings.glow,
          block_quotes = presets.block_quotes.obsidian,
        },
      })
    end
  },
  {
    'jakewvincent/mkdnflow.nvim',
    ft = { 'markdown', 'rmd' },
    config = function()
      require('mkdnflow').setup({
        modules = {
          conceal = false,
          yaml = false,
          completion = true,
        },
        to_do = {
          create_on_toggle = true,
          status_propagation = {
            up = false,
            down = false
          }
        },
        mappings = {
          MkdnTab = { 'i', '<Tab>' },
          MkdnSTab = { 'i', '<S-Tab>' },
          MkdnEnter = { { "n", "i" }, "<CR>" },
          MkdnNewListItem = false,
        }
      })
    end
  }
}
