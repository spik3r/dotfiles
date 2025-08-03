return {
	"saghen/blink.cmp",
	dependencies = {
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-nvim-lsp",
		"rafamadriz/friendly-snippets", -- Snippets for VSCode and more
		"L3MON4D3/LuaSnip", -- Snippet engine for LuaSnip
		"windwp/nvim-autopairs",
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")

		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body) -- Use LuaSnip for snippets
				end,
			},
			sources = {
				{ name = "nvim_lsp" }, -- LSP completion
				{ name = "path" }, -- File system paths
				{ name = "buffer" }, -- Completion from current buffer
				-- { name = "vsnip" }, -- VSCode snippets
				{ name = "luasnip" }, -- LuaSnip completions
			},
			mapping = cmp.mapping.preset.insert({
				["<CR>"] = cmp.mapping.confirm({ select = false }), -- Enter to confirm completion
				["<C-Space>"] = cmp.mapping.complete(), -- Trigger completion
				["<C-u>"] = cmp.mapping.scroll_docs(-4), -- Scroll documentation
				["<C-d>"] = cmp.mapping.scroll_docs(4), -- Scroll documentation
			}),
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
		})

		-- Load snippets from VSCode
		require("luasnip.loaders.from_vscode").lazy_load()

		-- Optionally, add custom snippets here if needed
	end,
}
