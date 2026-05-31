return {
  -- LazyVim language extras for the main stacks I use.
  { import = "lazyvim.plugins.extras.lang.dotnet" },
  { import = "lazyvim.plugins.extras.lang.dart" },
  { import = "lazyvim.plugins.extras.lang.go" },
  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "lazyvim.plugins.extras.lang.markdown" },
  { import = "lazyvim.plugins.extras.lang.tailwind" },
  { import = "lazyvim.plugins.extras.lang.terraform" },
  { import = "lazyvim.plugins.extras.lang.typescript" },
  { import = "lazyvim.plugins.extras.formatting.prettier" },
  { import = "lazyvim.plugins.extras.linting.eslint" },

  -- HTML/CSS are mostly covered by LazyVim core + Prettier; this makes their LSPs explicit.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        cssls = {},
        emmet_language_server = {},
        html = {},
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "css", "scss" } },
  },
}
