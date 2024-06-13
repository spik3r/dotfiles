-- return {}
-- Languages:
-- ts: npm install -g typescript typescript-language-server
-- dotnet: dotnet tool install --global csharp-ls
return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    ensure_installed = {
      "lua_ls",
      "eslint",
      "tsserver",
      "omnisharp",
    },
    config = function()
      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
    end,
  },
  {
    "williamboman/mason.nvim",
    lazy = false,
    opts = {
      ensure_installed = {
        "eslint-lsp",
        "js-debug-adapter",
        "prettier",
        "typescript-language-server",
        -- "csharp_ls",
        "omnisharp",
      },
    },
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "tsserver", "eslint", "omnisharp" },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- "nvimtools/none-ls-extras.nvim",
    },
    lazy = false,
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")
      local function organize_imports()
        local params = {
          command = "_typescript.organizeImports",
          arguments = { vim.api.nvim_buf_get_name(0) },
          title = ""
        }
        vim.lsp.buf.execute_command(params)
      end

      lspconfig.tsserver.setup({
        capabilities = capabilities,
        organize_imports_on_format = true,
        commands = {
          OrganizeImports = {
            organize_imports,
            description = "Organize Imports"
          }
        }
      })
      lspconfig.html.setup({
        capabilities = capabilities,
      })
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
      })
      lspconfig.omnisharp.setup({
        -- capabilities = capabilities
        cmd = { "omnisharp" },
        capabilities = capabilities,
        enable_roslyn_analysers = true,
        enable_import_completion = true,
        organize_imports_on_format = true,
        enable_decompilation_support = true,
        filetypes = { "cs", "vb", "csproj", "sln", "slnx", "props", "csx", "targets" },
      })
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
    end,
  },
}
