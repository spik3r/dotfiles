-- Languages:
-- ts: npm install -g typescript typescript-language-server
-- dotnet: dotnet tool install --global csharp-ls
return {
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",

		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					"lua_ls",
					"stylua",
					"lua-language-server",
					"gopls",
					"eslint",
					"ts_ls",
					"omnisharp",
					"codespell",
					"fourmolu",
					"pyright",
					"rust_analyzer",
					"marksman",
				},
			})
		end,
	},
}
