-- Add custom keymaps here.

vim.keymap.set({ "n", "v" }, "<leader>y", '"*y', { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", '"*Y', { desc = "Yank line to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>p", '"*p', { desc = "Paste from system clipboard" })

-- AeroSpace owns Alt-j/k globally; keep line movement available in the editor.
vim.keymap.set("n", "<leader>mj", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Line Down" })
vim.keymap.set("n", "<leader>mk", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Line Up" })
vim.keymap.set("v", "<leader>mj", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Selection Down" })
vim.keymap.set("v", "<leader>mk", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Selection Up" })
