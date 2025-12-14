return {
	--  {
	--    'echasnovski/mini.nvim',
	--    enabled = true,
	--    config = function()
	--      local statusline = require('mini.statusline')
	--      statusline.setup({ use_icons = true })
	-- 	end
	-- },
	{
		"nvim-lualine/lualine.nvim", -- Load the lualine plugin
		dependencies = {
			"nvim-tree/nvim-web-devicons", -- Optional: for devicons in lualine
		},
		config = function()
			-- Configure lualine here, after it's loaded
			require("lualine").setup({
				options = {
					section_separators = { left = "", right = "" },
					component_separators = { left = "", right = "" },
				},
			})
		end,
	},
}
