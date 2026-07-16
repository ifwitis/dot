return {
    {   
        "OXY2DEV/markview.nvim",
        lazy = false,
        config = {}
    },
    {
        'jakewvincent/mkdnflow.nvim',
        ft = { 'markdown', 'rmd' },
        opts = {
            mappings = false
        },
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
                }
            })
        end
    }
}
