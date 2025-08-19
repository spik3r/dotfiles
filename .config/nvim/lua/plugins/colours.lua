return {
	"catgoose/nvim-colorizer.lua",
	event = "BufReadPre",
	opts = {
		filetypes = { "*" }, -- Apply to all files
		user_default_options = {
			RGB = true, -- #RGB
			RGBA = true, -- #RGBA
			RRGGBB = true, -- #RRGGBB
			RRGGBBAA = true, -- #RRGGBBAA
			AARRGGBB = true, -- 0xAARRGGBB
			mode = "virtualtext", -- background | foreground | virtualtext
			virtualtext = "■",
			virtualtext_inline = true, -- true | "before" | "after"
			virtualtext_mode = "foreground",
		},
	},
	config = function(_, opts)
		require("colorizer").setup(opts)
	end,
}
