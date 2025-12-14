local set = vim.opt_local

-- Set local settings for terminal buffers
vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("custom-term-open", {}),
	pattern = "*",
	-- command = ":horizontal terminal",
	command = "startinsert",
	desc = "Auto enter insert mode when opening a terminal",
})

-- Easily hit escape in terminal mode.
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")

-- Make Ctrl K work in terminal mode
vim.keymap.set("t", "<c-k>", function()
	vim.cmd("stopinsert") -- This stops terminal mode
	vim.defer_fn(function()
		vim.api.nvim_input("<C-K>") -- Simulate <C-K> input in normal mode
	end, 10) -- 10ms delay to ensure it's processed correctly
end, { desc = "Exit terminal mode and move up" })

-- Open a terminal at the bottom of the screen with a fixed height.
vim.keymap.set("n", "<leader>tt", function()
	vim.cmd("botright split")
	vim.api.nvim_win_set_height(0, 12)
	vim.wo.winfixheight = true
	vim.cmd("term")
end, { desc = "Bottom terminal" })
