return {
    {
        "nvim-telescope/telescope-ui-select.nvim",
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }
        },
        branch = "master",
        config = function()
            local telescope = require("telescope")
            telescope.setup({
                pickers = {
                    find_files = {
                        -- Force find_files to use ripgrep and exclude binaries
                        find_command = { "rg", "--files", "--hidden", "--no-binary" },
                    },
                },
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({}),
                    },
                },
            })
            telescope.load_extension("ui-select")
            telescope.load_extension("fzf")
        end,
    },
}
