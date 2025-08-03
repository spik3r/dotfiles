vim.g.mapleader = " "
vim.g.maplocalleader = " "
require("config.lazy")

require("config.options")
require("config.keymaps")
-- my diff plugin
require("foo.foo").setup()
