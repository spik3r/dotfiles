return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local config = require("nvim-treesitter.configs")
    local ensure_installed = {
      "vim",
      "vimdoc",
      "bash",
      "dockerfile",
      "javascript",
      "typescript",
      "json",
      "lua",
      "markdown",
      "yaml",
    }
    config.setup({
      ignore_install = {},
      ensure_installed = ensure_installed,
      sync_install = false,
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
      modules = {}
    })
  end
}
