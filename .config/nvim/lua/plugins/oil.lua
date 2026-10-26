return {
  {
    "stevearc/oil.nvim",
    lazy = false,
    keys = {
      { "\\", "<cmd>Oil<cr>", desc = "Open parent directory", mode = "n" },
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
    },
    opts = {
      view_options = {
        show_hidden = true,
      },
    },
    dependencies = { "nvim-mini/mini.icons" },
  },
}
