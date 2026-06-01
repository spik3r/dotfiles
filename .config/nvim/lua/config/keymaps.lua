-- Add custom keymaps here.

vim.keymap.set({ "n", "v" }, "<leader>y", '"*y', { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", '"*Y', { desc = "Yank line to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>p", '"*p', { desc = "Paste from system clipboard" })
