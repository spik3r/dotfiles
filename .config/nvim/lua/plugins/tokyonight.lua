return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		transparent = true,
		-- dim_inactive = true,
		style = "moon",
		on_colors = function(colors)
			colors.border = "#FFB010"
		end,
		-- on_highlights = function(hl, c)
		--   hl.Normal = { bg = c.bg }
		--   -- hl.NormalNC = { bg = c.bg_dark }
		-- end,

		styles = {
			sidebars = "dark",
			floats = "light",
			terminal_colors = true,
		},
	},
	config = function(_, opts)
		local tokyonight = require("tokyonight")
		tokyonight.setup(opts)
		tokyonight.load()

		vim.api.nvim_set_hl(0, "TerminalNormal", {
			bg = "#1f2335", -- pick a Tokyonight bg you like
		})

		vim.api.nvim_set_hl(0, "TerminalNormalNC", {
			bg = "none", -- keep inactive terminals transparent
		})

		vim.api.nvim_create_autocmd({ "TermOpen", "WinEnter" }, {
			callback = function()
				if vim.bo.buftype == "terminal" then
					vim.wo.winhighlight = "Normal:TerminalNormal,NormalNC:TerminalNormalNC"
				end
			end,
		})

		vim.api.nvim_create_autocmd("WinLeave", {
			callback = function()
				if vim.bo.buftype == "terminal" then
					vim.wo.winhighlight = "Normal:TerminalNormalNC,NormalNC:TerminalNormalNC"
				end
			end,
		})
		-- Customize the terminal background color when opening a terminal
		-- vim.api.nvim_create_autocmd("TermEnter", {
		-- 	-- vim.api.nvim_create_autocmd("TermOpen", {
		-- 	pattern = "*",
		-- 	callback = function()
		-- 		vim.print(vim.api.nvim_get_chan_info(vim.bo.channel))
		-- 		print("TermOpen")
		-- 		-- vim.api.nvim_set_hl(0, "Normal", {
		-- 		-- 	bg = "#1f2335", -- active window
		-- 		-- })
		-- 		--
		-- 		-- vim.api.nvim_set_hl(0, "NormalNC", {
		-- 		-- 	bg = "#16161e", -- inactive windows
		-- 		-- })
		-- 		-- vim.api.nvim_set_hl(0, "Normal", {
		-- 		-- 	-- bg = "#24283b",
		-- 		-- })
		-- 		--
		-- 		-- vim.api.nvim_set_hl(0, "NormalNC", {
		-- 		-- 	-- bg = "NONE",
		-- 		-- 	bg = "#24283b",
		-- 		-- 	-- sp = "NONE",
		-- 		-- })
		-- 	end,
		-- })
		-- -- -- Custom highlight settings after colorscheme load
		-- vim.api.nvim_set_hl(0, "Terminal", {
		-- 	bg = "#282828", -- Solid background
		-- 	fg = "#FFFFFF", -- Text color
		-- })
		-- --
		-- vim.api.nvim_set_hl(0, "VertSplit", {
		-- 	fg = "#FF5733", -- Border color
		-- 	bg = "#282828", -- Background of the split border (not transparent)
		-- })
		--
		-- -- Define custom highlight group for a more distinct border
		-- vim.api.nvim_set_hl(0, "MyVertSplit", {
		-- 	fg = "#FF5733", -- Color of the split border
		-- 	bg = "#282828", -- Background color of the split
		-- })
		--
		-- -- Optionally log confirmation for debugging
		-- print("Custom VertSplit highlight set.")
	end,
}
