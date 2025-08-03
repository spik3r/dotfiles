return {
	-- Fugitive: Git wrapper inside Neovim
	{
		"tpope/vim-fugitive",
		cmd = {
			"G",
			"Gdiffsplit",
			"Gvdiffsplit",
			"Gwrite",
			"Gread",
			"Gblame",
		},
		keys = {
			{ "<leader>gs", ":G<CR>", desc = "Git status" },
			{ "<leader>gb", ":Gblame<CR>", desc = "Git blame" },
			{ "<leader>gd", ":Gdiffsplit<CR>", desc = "Git diff split" },
		},
	},

	-- Diffview: Better UI for reviewing diffs, commits, file history
	{
		"sindrets/diffview.nvim",
		cmd = {
			"DiffviewOpen",
			"DiffviewClose",
			"DiffviewFileHistory",
		},
		keys = {
			{ "<leader>do", ":DiffviewOpen<CR>", desc = "Open diffview" },
			{ "<leader>dc", ":DiffviewClose<CR>", desc = "Close diffview" },
			{ "<leader>dh", ":DiffviewFileHistory<CR>", desc = "File history" },
		},
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("diffview").setup({
				use_icons = false,
			})
		end,
	},
}
