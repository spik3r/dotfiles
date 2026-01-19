return {
	"seblyng/roslyn.nvim",
	enabled = true,
	ft = "cs",
	config = function()
		vim.lsp.config("roslyn", {
			on_attach = function()
				print("This will run when the server attaches!")
			end,
			settings = {
				-- Check settings in https://github.com/seblyng/roslyn.nvim
			},
		})
		local roslyn = require("roslyn")
		roslyn.setup()
	end,
}
