local M = {}

-- State to track windows and buffers
local state = {
	sidebar_win = -1,
	sidebar_buf = -1,
	left_win = -1,
	left_buf = -1,
	right_win = -1,
	right_buf = -1,
}

-- Namespace for highlights
local highlight_ns = vim.api.nvim_create_namespace("git_diff_highlights")

-- Function to retrieve changed files from git
local function get_changed_files(repo_path)
	local diff_output = vim.fn.systemlist("git -C " .. repo_path .. " diff --name-status")
	local files = {}
	for _, line in ipairs(diff_output) do
		local parts = vim.split(line, "%s+", { trimempty = true })
		if #parts >= 2 then
			table.insert(files, parts[2])
		end
	end
	return files
end

-- Function to create the sidebar window
M.create_sidebar_window = function(files, repo_path)
	local sidebar_buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(sidebar_buf, 0, -1, false, files)
	vim.bo[sidebar_buf].modifiable = false

	local width = math.floor(vim.o.columns * 0.15)
	local height = math.floor(vim.o.lines * 0.8)
	local col = 0
	local row = math.floor((vim.o.lines - height) / 2)

	local sidebar_win = vim.api.nvim_open_win(sidebar_buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal",
		border = "rounded",
		title = "foo.nvim", -- Add title to the sidebar
		title_pos = "center",
	})

	-- Set window options
	vim.wo[sidebar_win].wrap = false
	vim.wo[sidebar_win].number = false
	vim.wo[sidebar_win].cursorline = false

	-- Keymap to select a file
	vim.api.nvim_buf_set_keymap(
		sidebar_buf,
		"n",
		"<CR>",
		[[<cmd>lua require('foo.foo').select_file()<CR>]],
		{ noremap = true, silent = true }
	)

	-- Store the sidebar window and buffer
	state.sidebar_win = sidebar_win
	state.sidebar_buf = sidebar_buf
	state.repo_path = repo_path
end

-- Function to handle file selection in the sidebar
M.select_file = function()
	local sidebar_buf = state.sidebar_buf
	local selected_line = vim.api.nvim_buf_get_lines(sidebar_buf, vim.fn.line(".") - 1, vim.fn.line("."), false)[1]
	local file_path = state.repo_path .. "/" .. selected_line

	-- Check if the file exists
	if vim.fn.filereadable(file_path) == 0 then
		print("Error: File does not exist - " .. file_path)
		return
	end

	M.close_diff_windows()
	M.show_git_diff_for_file(file_path)
end

-- Function to parse git diff output and align lines with gaps
local function parse_git_diff(diff_output)
	local original = {}
	local modified = {}
	local deletions = {}
	local additions = {}

	for _, line in ipairs(diff_output) do
		if line:match("^%-") then
			table.insert(original, line:sub(2))
			table.insert(deletions, #original)
			table.insert(modified, "") -- Add gap in modified
		elseif line:match("^%+") then
			table.insert(modified, line:sub(2))
			table.insert(additions, #modified)
			table.insert(original, "") -- Add gap in original
		else
			table.insert(original, line:sub(2))
			table.insert(modified, line:sub(2))
		end
	end

	return original, modified, deletions, additions
end

-- Function to highlight lines in a buffer
local function highlight_lines(buf, lines, hl_group)
	for _, line in ipairs(lines) do
		if line ~= "" then
			vim.api.nvim_buf_add_highlight(buf, highlight_ns, hl_group, line - 1, 0, -1)
		end
	end
end

-- Function to display the git diff in side-by-side windows
M.show_git_diff_for_file = function(file_path)
	local git_repo_path =
		vim.fn.systemlist("git -C " .. vim.fn.fnamemodify(file_path, ":h") .. " rev-parse --show-toplevel")[1]
	local git_diff_output = vim.fn.systemlist("git -C " .. git_repo_path .. " diff " .. file_path)

	-- Parse the git diff output
	local original, modified, deletions, additions = parse_git_diff(git_diff_output)

	-- Create the floating windows for diff
	local width = math.floor(vim.o.columns * 0.85)
	local height = math.floor(vim.o.lines * 0.8)
	local col = math.floor(vim.o.columns * 0.15)
	local row = math.floor((vim.o.lines - height) / 2)

	local left_win_config = {
		relative = "editor",
		width = math.floor(width * 0.5),
		height = height,
		col = col,
		row = row,
		style = "minimal",
		border = "rounded",
		title = "Original", -- Add title to the left window
		title_pos = "center",
	}

	local right_win_config = {
		relative = "editor",
		width = math.floor(width * 0.5),
		height = height,
		col = col + math.floor(width * 0.5),
		row = row,
		style = "minimal",
		border = "rounded",
		title = "Modified", -- Add title to the right window
		title_pos = "center",
	}

	local left_buf = vim.api.nvim_create_buf(false, true)
	local right_buf = vim.api.nvim_create_buf(false, true)

	local left_win = vim.api.nvim_open_win(left_buf, true, left_win_config)
	local right_win = vim.api.nvim_open_win(right_buf, true, right_win_config)

	-- Store the window and buffer references
	state.left_win = left_win
	state.left_buf = left_buf
	state.right_win = right_win
	state.right_buf = right_buf

	-- Set the content of the buffers
	vim.api.nvim_buf_set_lines(left_buf, 0, -1, false, original)
	vim.api.nvim_buf_set_lines(right_buf, 0, -1, false, modified)

	-- Highlight changes
	highlight_lines(left_buf, deletions, "DiffDelete")
	highlight_lines(right_buf, additions, "DiffAdd")

	-- Link scroll positions
	vim.wo[left_win].scrollbind = true
	vim.wo[right_win].scrollbind = true

	-- Add line numbers
	vim.wo[left_win].number = true
	vim.wo[right_win].number = true
	-- -- Link scroll positions
	-- vim.api.nvim_win_set_option(left_win, "scrollbind", true)
	-- vim.api.nvim_win_set_option(right_win, "scrollbind", true)
	--
	-- -- Add line numbers
	-- vim.api.nvim_win_set_option(left_win, 'number', true)
	-- vim.api.nvim_win_set_option(right_win, 'number', true)

	-- Add keymaps for navigation
	vim.api.nvim_buf_set_keymap(
		left_buf,
		"n",
		"<C-l>",
		[[<cmd>lua require('foo.foo').focus_right()<CR>]],
		{ noremap = true, silent = true }
	)
	vim.api.nvim_buf_set_keymap(
		right_buf,
		"n",
		"<C-h>",
		[[<cmd>lua require('foo.foo').focus_left()<CR>]],
		{ noremap = true, silent = true }
	)
	vim.api.nvim_buf_set_keymap(
		left_buf,
		"n",
		"<C-j>",
		[[<cmd>lua require('foo.foo').focus_sidebar()<CR>]],
		{ noremap = true, silent = true }
	)
	vim.api.nvim_buf_set_keymap(
		right_buf,
		"n",
		"<C-j>",
		[[<cmd>lua require('foo.foo').focus_sidebar()<CR>]],
		{ noremap = true, silent = true }
	)
end

-- Function to focus the left diff window
M.focus_left = function()
	if vim.api.nvim_win_is_valid(state.left_win) then
		vim.api.nvim_set_current_win(state.left_win)
	end
end

-- Function to focus the right diff window
M.focus_right = function()
	if vim.api.nvim_win_is_valid(state.right_win) then
		vim.api.nvim_set_current_win(state.right_win)
	end
end

-- Function to focus the sidebar
M.focus_sidebar = function()
	if vim.api.nvim_win_is_valid(state.sidebar_win) then
		vim.api.nvim_set_current_win(state.sidebar_win)
	end
end

-- Function to toggle the sidebar
M.toggle_diff_sidebar = function(repo_path)
	if vim.api.nvim_buf_is_valid(state.sidebar_buf) then
		M.close_diff_sidebar()
	else
		local files = get_changed_files(repo_path)
		if #files == 0 then
			print("No changed files to display.")
			return
		end
		M.create_sidebar_window(files, repo_path)
	end
end

-- Function to close the sidebar
M.close_diff_sidebar = function()
	if vim.api.nvim_buf_is_valid(state.sidebar_buf) then
		vim.api.nvim_win_close(state.sidebar_win, true)
		vim.api.nvim_buf_delete(state.sidebar_buf, { force = true })
		state.sidebar_win = -1
		state.sidebar_buf = -1
	end
end

-- Function to toggle the diff view for the current file
M.toggle_diff = function()
	if vim.api.nvim_buf_is_valid(state.left_buf) and vim.api.nvim_buf_is_valid(state.right_buf) then
		M.close_diff_windows()
	else
		local file_path = vim.fn.expand("%:p")
		M.show_git_diff_for_file(file_path)
	end
end

-- Function to close the diff windows
M.close_diff_windows = function()
	if vim.api.nvim_buf_is_valid(state.left_buf) then
		vim.api.nvim_win_close(state.left_win, true)
		vim.api.nvim_buf_delete(state.left_buf, { force = true })
	end
	if vim.api.nvim_buf_is_valid(state.right_buf) then
		vim.api.nvim_win_close(state.right_win, true)
		vim.api.nvim_buf_delete(state.right_buf, { force = true })
	end
end

-- Function to close all plugin-related windows and buffers
M.close_diff = function()
	M.close_diff_sidebar()
	M.close_diff_windows()
end

function M.hello()
	print("hello from plugin")
end

-- Setup keybindings
M.setup = function()
	vim.keymap.set("n", "<leader>fb", M.hello)
	vim.keymap.set("n", "<leader>fo", function()
		local repo_path = vim.fn.resolve(vim.fn.expand("%:p:h")) -- Resolve symlinks
		M.toggle_diff_sidebar(repo_path)
	end)
	vim.keymap.set("n", "<leader>Fo", function()
		local repo_path = vim.fn.expand("~/code/website") -- Hardcoded directory
		M.toggle_diff_sidebar(repo_path)
	end)
	vim.keymap.set("n", "<leader>fd", M.toggle_diff) -- Toggle diff for current file
	vim.keymap.set("n", "<leader>fc", M.close_diff) -- Close all plugin windows
end

-- Define highlight groups
vim.cmd([[
  highlight DiffAdd guifg=#4caf50 guibg=NONE
  highlight DiffDelete guifg=#f44336 guibg=NONE
]])

return M
