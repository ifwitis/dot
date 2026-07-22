return {
	"glepnir/lspsaga.nvim",
	event = "LspAttach",
	lazy = false,
	config = function()
		require("lspsaga").setup({
			ui = {
				border = "single",
				devicon = true,
				title = true,
				expand = "◂",
				collapse = "▾",
			},
			lightbulb = {
				sign = false,
			},
			-- Navigation within lspsaga window
			scroll_preview = {
				scroll_up = "<C-k>",
				scroll_down = "<C-j>",
			},
			-- Use enter to open file with finder
			finder = {
				keys = {
					toggle_or_open = "<CR>",
					vsplit = "v",
					split = "s",
					tabe = "t",
					quit = "q",
				},
			},
			-- Use enter to open file with definition preview
			definition = {
				keys = {

					edit = "<CR>",
				},
			},
		})
	end,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"nvim-treesitter/nvim-treesitter",
	},
}
