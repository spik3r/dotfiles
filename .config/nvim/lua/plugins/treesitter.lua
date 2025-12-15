return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		-- init.lua or plugins/treesitter.lua
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				-- "go",
				"rust",
				"lua",
				"typescript",
				"c_sharp",
				"terraform",
				"hcl",
			},
			sync_install = false,
			auto_install = true,

			highlight = {
				enable = false,
				additional_vim_regex_highlighting = false,
			},

			indent = {
				enable = true,
			},

			-- Optional: context-aware commentstrings (e.g. // for JS, -- for Lua)
			context_commentstring = {
				enable = true,
				enable_autocmd = false,
			},
		})
	end,
}
