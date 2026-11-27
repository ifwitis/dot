return {
  "nvim-tree/nvim-tree.lua",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<leader>tr", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file tree" },
    { "<leader>rt", "<cmd>NvimTreeFocus<CR>",  desc = "Focus file tree" },
  },
  config = function()
    vim.cmd([[hi NvimTreeNormal guibg=NONE ctermbg=NONE]])
    require("nvim-tree").setup({
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      filters = {
        dotfiles = false,         -- Show hidden files (dotfiles)
      },
      view = {
        adaptive_size = true,
      },
      update_focused_file = {
        enable = true,
        update_root = false,
      },
    })
  end
}
