return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim", -- Ensure mason is loaded first
		"hrsh7th/cmp-nvim-lsp", -- nvim-cmp integration with LSP
	},
	config = function()
		local lspconfig = require("lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		-- Enhance LSP capabilities with nvim-cmp
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- lspconfig.tsserver.setup({
		lspconfig.ts_ls.setup({
			capabilities = capabilities,
			settings = {
				-- Add specific settings to improve the LSP experience
				javascript = {
					suggest = {
						autoImports = true, -- Enable auto imports for JS
						completeFunctionCalls = true, -- Complete function calls
					},
				},
				typescript = {
					suggest = {
						autoImports = true, -- Enable auto imports for TypeScript
						completeFunctionCalls = true, -- Complete function calls
					},
				},
			},
			on_attach = function(client, bufnr)
				-- Enable signature help (shows function signatures)
				vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { buffer = bufnr })

				-- Enable diagnostics (shows errors/warnings)
				vim.diagnostic.config({
					virtual_text = true,
					signs = true,
					underline = true,
				})
			end,
		})
		-- Set up LSP servers for various languages
		lspconfig.lua_ls.setup({
			capabilities = capabilities,
		})
		-- lspconfig.tsserver.setup({
		lspconfig.ts_ls.setup({
			capabilities = capabilities,
		})
		lspconfig.html.setup({
			capabilities = capabilities,
		})
		lspconfig.cssls.setup({
			capabilities = capabilities,
		})
		lspconfig.gopls.setup({
			capabilities = capabilities,
		})
		lspconfig.rust_analyzer.setup({
			capabilities = capabilities,
		})
		lspconfig.hls.setup({
			capabilities = capabilities,
		})
		lspconfig.pyright.setup({
			capabilities = capabilities,
		})

		-- lspconfig.omnisharp.setup({
		--   capabilities = capabilities,
		-- })
		lspconfig.omnisharp.setup({
			cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
			capabilities = require("cmp_nvim_lsp").default_capabilities(),
			on_attach = function(client, bufnr)
				-- Key mappings for OmniSharp
				vim.keymap.set("n", "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<cr>", { buffer = bufnr })
				vim.keymap.set("n", "<leader>gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", { buffer = bufnr })
			end,
		})

		-- Autocommand to handle LSP key mappings when LSP attaches to buffer
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(event)
				local opts = { buffer = event.buf }

				-- LSP key mappings
				vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
				vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
				vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
				vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
				vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
				vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
				vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
				vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
				-- vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
				vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
			end,
		})
	end,
}
