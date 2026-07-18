return {
    {
        "nvim-telescope/telescope-ui-select.nvim",
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        branch = "master",
        config = function()
            require("telescope").setup({
                defaults = {
                    -- Sorts results by most recently modified when fuzzy scores tie
                    tiebreak = function(current_entry, existing_entry, prompt)
                        return current_entry.stat.mtime < existing_entry.stat.mtime
                    end,
                },
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

            require("telescope").load_extension("ui-select")
        end,
    },
}
