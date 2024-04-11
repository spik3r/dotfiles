return {
  "nureim-treesitter/nvim-treesitter",
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
      ensure_installed = ensure_installed,
      sync_install = false,
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end
}
