-- return {}
return {
	-- {
	-- 	"tpope/vim-fugitive",
	-- },
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
			vim.keymap.set("n", "<leader>hp", ":Gitsigns preview_hunk<CR>", {})
			vim.keymap.set("n", "<leader>tb", ":Gitsigns toggle_current_line_blame<CR>", {})
		end,
	},
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"sindrets/diffview.nvim", -- optional - Diff integration

			-- Only one of these is needed, not both.
			"nvim-telescope/telescope.nvim", -- optional
			-- "ibhagwan/fzf-lua",              -- optional
		},
		config = function()
			print("loaded neogit")
			require("neogit").setup({})
			vim.keymap.set("n", "<leader>gs", ":Neogit<CR>", { silent = true, noremap = true })
			vim.keymap.set("n", "<leader>gc", ":Neogit commit<CR>", { silent = true, noremap = true })
			vim.keymap.set("n", "<leader>gp", ":Neogit pull<CR>", { silent = true, noremap = true })
			vim.keymap.set("n", "<leader>gP", ":Neogit push<CR>", { silent = true, noremap = true })
			vim.keymap.set("n", "<leader>gb", ":Telescope git_branches<CR>", { silent = true, noremap = true })
			vim.keymap.set("n", "<leader>gB", ":G blame<CR>", { silent = true, noremap = true })
		end,
		-- config = true,
	},
	-- config = function()
	-- local neogit = require("neogit").setup(true)

	-- end,
}
