return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  keys = {
    { "\\", ":Neotree filesystem toggle right<CR>", { desc = "NeoTree toggle" } },
  },

  config = function()
    require("neo-tree").setup({
      filesystem = {
        follow_current_file = {
          enabled = true,          -- This will find and focus the file in the active buffer every time
          --               -- the current file is changed while the tree is open.
          leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
        },
      },
      -- buffers = {
      --   follow_current_file = { enabled = true, -- This will find and focus the file in the active buffer every time -- -- the current file is changed while the tree is open.
      --   }
      -- }
    })
  end
}
