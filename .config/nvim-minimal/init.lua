require("options")
require("keymaps")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme tokyonight]])

			-- Customize LSP popup colors
			vim.api.nvim_create_autocmd("ColorScheme", {
				callback = function()
					-- Make hover popups more distinct with better contrast
					vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1a1b26", fg = "#c0caf5" })
					vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#7aa2f7", bold = true })
					vim.api.nvim_set_hl(0, "FloatTitle", { bg = "#7aa2f7", fg = "#1a1b26", bold = true })

					-- Completion menu styling
					vim.api.nvim_set_hl(0, "Pmenu", { bg = "#16161e", fg = "#c0caf5" })
					vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#283457", fg = "#c0caf5", bold = true })
					vim.api.nvim_set_hl(0, "PmenuSbar", { bg = "#16161e" })
					vim.api.nvim_set_hl(0, "PmenuThumb", { bg = "#545c7e" })

					-- Additional LSP-related highlights
					vim.api.nvim_set_hl(0, "LspInfoBorder", { fg = "#7dcfff", bold = true })
					vim.api.nvim_set_hl(0, "DiagnosticFloatingError", { fg = "#f7768e" })
					vim.api.nvim_set_hl(0, "DiagnosticFloatingWarn", { fg = "#e0af68" })
					vim.api.nvim_set_hl(0, "DiagnosticFloatingInfo", { fg = "#0db9d7" })
					vim.api.nvim_set_hl(0, "DiagnosticFloatingHint", { fg = "#1abc9c" })
				end,
			})

			-- Apply colors immediately
			vim.cmd("doautocmd ColorScheme")
		end,
	},

	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local harpoon = require("harpoon")
			harpoon:setup()

			vim.keymap.set("n", "<leader>a", function()
				harpoon:list():add()
			end)
			vim.keymap.set("n", "<leader>A", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end)

			vim.keymap.set("n", "<leader>1", function()
				harpoon:list():select(1)
			end)
			vim.keymap.set("n", "<leader>2", function()
				harpoon:list():select(2)
			end)
			vim.keymap.set("n", "<leader>3", function()
				harpoon:list():select(3)
			end)
			vim.keymap.set("n", "<leader>4", function()
				harpoon:list():select(4)
			end)
		end,
	},

	{
		"stevearc/oil.nvim",
		config = function()
			require("oil").setup({
				default_file_explorer = true,
				delete_to_trash = true,
				skip_confirm_for_simple_edits = true,
				view_options = {
					show_hidden = true,
					natural_order = true,
				},
			})
			vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
		end,
	},

	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("trouble").setup()
			vim.keymap.set("n", "<leader>xx", function()
				require("trouble").toggle("diagnostics")
			end)
			vim.keymap.set("n", "<leader>xw", function()
				require("trouble").toggle("diagnostics")
			end)
			vim.keymap.set("n", "<leader>xd", function()
				require("trouble").toggle("diagnostics", { filter = { buf = 0 } })
			end)
			vim.keymap.set("n", "<leader>xq", function()
				require("trouble").toggle("quickfix")
			end)
			vim.keymap.set("n", "<leader>xl", function()
				require("trouble").toggle("loclist")
			end)
			vim.keymap.set("n", "gR", function()
				require("trouble").toggle("lsp_references")
			end)
		end,
	},

	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
				}),
			})

			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
			})
		end,
	},

	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"ts_ls",
					"eslint",
					"marksman",
					"jsonls",
					"omnisharp",
					-- "gopls", -- Install manually if auto-install fails
					"rust_analyzer",
					"pyright",
					"terraformls",
					"yamlls",
					"dockerls",
				},
				automatic_installation = true,
			})
		end,
	},

	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		config = function()
			require("noice").setup({
				lsp = {
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
				},
				presets = {
					bottom_search = true,
					command_palette = true,
					long_message_to_split = true,
					inc_rename = false,
					lsp_doc_border = true,
				},
			})
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "tokyonight",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { "filename" },
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
			})
		end,
	},

	{
		"folke/flash.nvim",
		event = "VeryLazy",
		config = function()
			require("flash").setup()
		end,
		keys = {
			{ "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
			{ "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
			{ "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
			{ "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
			{ "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
		},
	},

	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup({
				defaults = {
					layout_config = {
						horizontal = { preview_width = 0.6 },
					},
				},
			})
		end,
		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
			{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
			{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
			{ "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
			{ "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace Symbols" },
			{ "<leader>fr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
		},
	},

	"MunifTanjim/nui.nvim",
	"rcarriga/nvim-notify",
	"nvim-tree/nvim-web-devicons",
	"nvim-lua/plenary.nvim",
})

-- Native LSP Setup (Neovim 0.11+)
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Setup LSP hover window with dynamic sizing
vim.api.nvim_create_autocmd({ 'VimEnter', 'VimResized' }, {
  desc = 'Setup LSP hover window',
  callback = function()
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.4)

    vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
      border = 'rounded',
      title = ' 📖 Documentation ',
      title_pos = 'center',
      max_width = width,
      max_height = height,
      focusable = true,
      wrap = true,
    })

    vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = 'rounded',
      title = ' ✏️  Signature Help ',
      title_pos = 'center',
      max_width = width,
      max_height = math.floor(height * 0.6),
      focusable = true,
      wrap = true,
    })
  end,
})

-- Test that borders work
vim.api.nvim_create_user_command("TestFloat", function()
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "This is a test", "with borders" })
	vim.api.nvim_open_win(buf, false, {
		relative = "cursor",
		width = 20,
		height = 2,
		row = 1,
		col = 0,
		border = "rounded",
		title = "Test",
		title_pos = "center",
	})
end, {})

-- Configure diagnostic popup and signs
vim.diagnostic.config({
	float = {
		border = "rounded",
		source = "always",
	},
	virtual_text = {
		prefix = "●",
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.HINT] = " ",
			[vim.diagnostic.severity.INFO] = " ",
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

-- LSP keymaps
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		local bufnr = args.buf
		local opts = { buffer = bufnr }

		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set("n", "<space>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<space>f", function()
			vim.lsp.buf.format({ async = true })
		end, opts)

		-- Additional LSP info commands with better error handling
		vim.keymap.set("n", "<space>t", function()
			local params = vim.lsp.util.make_position_params()
			vim.lsp.buf_request(bufnr, 'textDocument/typeDefinition', params, function(err, result, ctx, config)
				if err then
					print("Type definition error: " .. err.message)
					return
				end
				if not result or vim.tbl_isempty(result) then
					print("No type definition found")
					return
				end
				vim.lsp.util.jump_to_location(result[1], client.offset_encoding or 'utf-16')
			end)
		end, opts)

		vim.keymap.set("n", "<space>i", function()
			local params = vim.lsp.util.make_position_params()
			vim.lsp.buf_request(bufnr, 'textDocument/implementation', params, function(err, result, ctx, config)
				if err then
					print("Implementation error: " .. err.message)
					return
				end
				if not result or vim.tbl_isempty(result) then
					print("No implementation found")
					return
				end
				vim.lsp.util.jump_to_location(result[1], client.offset_encoding or 'utf-16')
			end)
		end, opts)

		vim.keymap.set("n", "<space>s", vim.lsp.buf.signature_help, opts) -- Show signature help
		vim.keymap.set("n", "<space>h", vim.lsp.buf.hover, opts) -- Alternative hover

		-- Workspace and symbol commands
		vim.keymap.set("n", "<space>ws", vim.lsp.buf.workspace_symbol, opts) -- Search workspace symbols
		vim.keymap.set("n", "<space>ds", vim.lsp.buf.document_symbol, opts) -- List document symbols

		-- Incoming/outgoing calls (if supported)
		vim.keymap.set("n", "<space>ci", vim.lsp.buf.incoming_calls, opts) -- Show incoming calls
		vim.keymap.set("n", "<space>co", vim.lsp.buf.outgoing_calls, opts) -- Show outgoing calls

		-- Custom diagnostic float keymap
		vim.keymap.set("n", "<space>d", function()
			vim.diagnostic.open_float({
				border = "rounded",
				title = " ⚠️  Diagnostics ",
				title_pos = "center",
				source = "always",
			})
		end, opts)
	end,
})

-- Enable LSP servers
local servers = {
	"lua_ls",
	"ts_ls",
	"eslint",
	"marksman",
	"jsonls",
	"omnisharp",
	"gopls",
	"rust_analyzer",
	"pyright",
	"terraformls",
	"yamlls",
	"dockerls",
}

for _, server in ipairs(servers) do
	vim.lsp.enable(server)
end
