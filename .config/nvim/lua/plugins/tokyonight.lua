return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		transparent = true,
		styles = {
			sidebars = "transparent",
			floats = "transparent",
		},
	},
	config = function(_, opts)
		local tokyonight = require("tokyonight")
		tokyonight.setup(opts)
		tokyonight.load()
		-- vim.cmd([[colorscheme tokyonight-moon]])
		-- vim.cmd[[colorscheme tokyonight-night]]
	end,
}
