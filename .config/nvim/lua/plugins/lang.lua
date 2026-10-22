-- Homebrew's dotnet wrapper sets this only for dotnet itself. Tool apphosts
-- otherwise search the older system-wide runtime in /usr/local/share/dotnet.
local dotnet_root = (vim.env.HOMEBREW_PREFIX or "/opt/homebrew") .. "/opt/dotnet/libexec"

return {
  { "iamcco/markdown-preview.nvim", enabled = false },
  { "Hoffs/omnisharp-extended-lsp.nvim", enabled = false },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        cssls = {},
        emmet_language_server = {},
        html = {},
        fsautocomplete = { cmd_env = { DOTNET_ROOT = dotnet_root } },
        omnisharp = { enabled = false },
        roslyn_ls = { cmd_env = { DOTNET_ROOT = dotnet_root } },
      },
      setup = {
        roslyn_ls = function(_, opts)
          -- Roslyn derives its child runtime path from the dotnet executable;
          -- point it at the host binary rather than Homebrew's shell wrapper.
          opts.cmd_env.PATH = dotnet_root .. ":" .. vim.env.PATH
        end,
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "css", "scss" } },
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "rust-analyzer", "ruff" } },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        csharpier = { env = { DOTNET_ROOT = dotnet_root } },
        fantomas = { env = { DOTNET_ROOT = dotnet_root } },
      },
      formatters_by_ft = {
        python = { "ruff_organize_imports", "ruff_format" },
      },
    },
  },
}
