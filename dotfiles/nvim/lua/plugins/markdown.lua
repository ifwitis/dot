return {
    {
        "brianhuster/live-preview.nvim",
        ft = { "markdown", "html", "svg" },
        opts = {},
        cmd = { "LivePreview" },
    },
    {
        "OXY2DEV/markview.nvim",
        ft = { 'markdown' },
        lazy = true,
        config = function()
            local presets = require("markview.presets")
            require("markview").setup({
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
            })
        end
    },
    {
        'jakewvincent/mkdnflow.nvim',
        ft = { 'markdown', 'rmd' },
        lazy = true,
        config = function()
            require('mkdnflow').setup({
                modules = {
                    bib = true,
                    buffers = true,
                    conceal = true,
                    cursor = true,
                    folds = true,
                    foldtext = true,
                    links = true,
                    lists = true,
                    maps = true,
                    paths = true,
                    tables = true,
                    templates = true,
                    to_do = true,
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
                }
            })
        end
    }
}
