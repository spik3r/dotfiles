return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- flutter-tools owns dartls so Flutter commands, outline, device
        -- switching, hot reload, and DevTools all share one LSP instance.
        dartls = { enabled = false },
      },
    },
  },
  {
    "akinsho/flutter-tools.nvim",
    ft = "dart",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>Fr", "<cmd>FlutterRun<cr>", desc = "Flutter Run" },
      { "<leader>Fq", "<cmd>FlutterQuit<cr>", desc = "Flutter Quit" },
      { "<leader>FR", "<cmd>FlutterReload<cr>", desc = "Flutter Hot Reload" },
      { "<leader>FS", "<cmd>FlutterRestart<cr>", desc = "Flutter Hot Restart" },
      { "<leader>Fd", "<cmd>FlutterDevices<cr>", desc = "Flutter Devices" },
      { "<leader>Fe", "<cmd>FlutterEmulators<cr>", desc = "Flutter Emulators" },
      { "<leader>Fo", "<cmd>FlutterOutlineToggle<cr>", desc = "Flutter Outline" },
      { "<leader>Fl", "<cmd>FlutterLogToggle<cr>", desc = "Flutter Logs" },
      { "<leader>Ft", "<cmd>FlutterDevTools<cr>", desc = "Flutter DevTools" },
    },
    opts = {
      decorations = {
        statusline = {
          app_version = true,
          device = true,
        },
      },
      dev_log = {
        enabled = true,
        open_cmd = "tabedit",
      },
      outline = {
        open_cmd = "30vnew",
      },
      widget_guides = {
        enabled = true,
      },
      closing_tags = {
        enabled = true,
      },
      lsp = {
        color = {
          enabled = true,
          background = false,
          virtual_text = true,
          virtual_text_str = "■",
        },
        settings = {
          completeFunctionCalls = true,
          showTodos = true,
        },
      },
    },
  },
}
