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
    keys = {
      {
        "<leader>ff",
        function() require("telescope.builtin").find_files() end,
        desc = "Find files",
      },
      {
        "<leader>fg",
        function() require("telescope.builtin").live_grep() end,
        desc = "Live grep",
      },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        pickers = {
          find_files = {
            hidden = true,
            follow = true,
            -- force telescope to use ripgrep
            find_command = {
              "rg",
              "--files",
              "--hidden",
              "--follow",
              "--glob", "!.git",
              "--glob", "!Library",
              "--glob", "!.cache",
              "--glob", "!.local",
              "--glob", "!.npm",
              "--glob", "!.cargo",
              "--glob", "!node_modules",
            },
          }
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
