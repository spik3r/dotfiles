return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	config = function()
		require("nvim-autopairs").setup({
			check_ts = true, -- Enable Treesitter integration (for language-aware pairs)
			disable_filetype = { "TelescopePrompt", "vim" }, -- Disable in some filetypes
			fast_wrap = {
				map = "<M-e>", -- Alt+e to trigger a quick wrap
				chars = { "{", "[", "(", '"', "'" }, -- Characters for fast wrapping
				pattern = string.gsub([[ [%'%"%>%]%)%}%,] ]], "%s+", ""),
				offset = 0, -- Offset for cursor
				keys = "abcdefghijklmnopqrstuvwxyz", -- Quick wrap keys
				check_comma = true,
			},
		})
	end,
}
