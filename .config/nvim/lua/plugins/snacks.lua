return {
  {
    "folke/snacks.nvim",
    keys = {
      {
        "\\",
        function()
          Snacks.explorer({ cwd = LazyVim.root() })
        end,
        desc = "Explorer Snacks (root dir)",
      },
    },
  },
}
