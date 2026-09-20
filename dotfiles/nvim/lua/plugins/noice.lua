return {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
        notify = {
            enabled = true,
            view = "notify",
            view_error = "notify",
            view_warn = "notify",
            view_history = "messages",
            view_search = false,
        },
        messages = {
            view_search = "mini",
        }
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
            },
        },
    },
}
