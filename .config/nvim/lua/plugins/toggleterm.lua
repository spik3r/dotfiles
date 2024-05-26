return {
	"akinsho/toggleterm.nvim",
	version = "*",
	opts = {
		size = 10,
		open_mapping = "<leader-t>",
		-- open_mapping = "<C-\\>",
		shade_terminals = false,
		persist_size = true,
		direction = "horizontal",
		close_on_exit = true,
		highlights = {
			Normal = {
				guibg = "#1a1b26",
			},
			SignColumn = {
				guibg = "#1a1b26",
			},
		},
		float_opts = {
			winblend = 0,
		},
	},
}
