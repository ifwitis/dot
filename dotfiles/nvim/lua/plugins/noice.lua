return {
  "folke/noice.nvim",
  event = "VeryLazy",
  cmd = "Noice",
  keys = {
    { "<leader>nm", "<cmd>Noice last<CR>",    desc = "Show last message" },
    { "<leader>nh", "<cmd>Noice all<CR>",     desc = "Show message history" },
    { "<leader>nd", "<cmd>Noice dismiss<CR>", desc = "Dismiss notifications" },
  },
  opts = {
    popupmenu = {
      enabled = false,
    },
    notify = {
      enabled = true,
      view = "notify",
    },
    messages = {
      enabled = true,
      view = "notify",
      view_error = "notify",
      view_warn = "notify",
      view_history = "messages",
      view_search = "mini",
    },
    lsp = {
      hover = {
        enabled = false,
      },
      signature = {
        enabled = false,
      },
      progress = {
        enabled = true,
        view = "mini",
      },
    },
    presets = {
      long_message_to_split = true,
    },
  },
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    {
      "rcarriga/nvim-notify",
      opts = {
        stages = "static",
        max_width = 80,
        max_height = 40,
        timeout = 3000,
        background_color = "#000000",
      },
    },
  },
}
