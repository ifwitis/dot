return {
    "christoomey/vim-tmux-navigator",
    cmd = {
        "TmuxNavigateLeft",
        "TmuxNavigateDown",
        "TmuxNavigateUp",
        "TmuxNavigateRight",
    },
    keys = {
        { "<leader>wh", "<cmd>TmuxNavigateLeft<cr>" },
        { "<leader>wj", "<cmd>TmuxNavigateDown<cr>" },
        { "<leader>wk", "<cmd>TmuxNavigateUp<cr>" },
        { "<leader>wl", "<cmd>TmuxNavigateRight<cr>" },
    },
}
