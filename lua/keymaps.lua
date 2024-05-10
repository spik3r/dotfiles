-- vim.keymap.set({"n", "v"}, "<leader>y", [["+y<CR>]])
-- vim.keymap.set({"n", "v"}, "<leader>p", [["+p<CR>]])
-- -- copy & paste from system clipboard

-- -- page up / down and center cursor
-- vim.keymap.set('n', '<C-d>', '<C-d>zz')
-- vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- -- resource
-- vim.keymap.set('n', '<leader>r', '<cmd>so<CR>')
-- vim.keymap.set('n', '<leader>z', '<cmd>echo "leader z Not mapped yet"<CR>')

-- -- Set highlight on search, but clear on pressing <Esc> in normal mode
-- vim.opt.hlsearch = true
-- vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')


-- -- Diagnostic keymaps
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- -- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- -- https://stackoverflow.com/a/15399297
-- -- <ALT+j> ==> ª 
-- -- <ALT+k> ==> º
-- vim.api.nvim_set_keymap('n', '<ª>', ':m .+1<CR>==', { noremap = true, silent = true }) --up
-- vim.api.nvim_set_keymap('n', '<º>', ':m .-2<CR>==', { noremap = true, silent = true }) -- down
-- vim.api.nvim_set_keymap('v', '<ª>', ':m \'>+1<CR>gv=gv', { noremap = true, silent = true }) -- up
-- vim.api.nvim_set_keymap('v', '<º>', ':m \'<-2<CR>gv=gv', { noremap = true, silent = true }) -- down
-- vim.api.nvim_set_keymap('i', '<ª>', '<Esc>:m .-2<CR>==gi', { noremap = true, silent = true }) -- up
-- vim.api.nvim_set_keymap('i', '<º>', '<Esc>:m .+1<CR>==gi', { noremap = true, silent = true }) -- down

-- vim.api.nvim_set_keymap('n', '<Leader>d', ':.t.<CR>', { silent = true }) -- duplicate line
-- vim.api.nvim_set_keymap('v', '<Leader>d', ':\'<,\'>t\'>+1<CR>', { silent = true }) -- duplicate line

-- -- map("n", "<A-j>", ":m .+1<CR>==") -- move line up(n)
-- -- map("n", "<A-k>", ":m .-2<CR>==") -- move line down(n)
-- -- map("v", "<A-j>", ":m '>+1<CR>gv=gv") -- move line up(v)
-- -- map("v", "<A-k>", ":m '<-2<CR>gv=gv") -- move line down(v)
-- -- Keybinds to make split navigation easier.

-- -- map("n", "<A-j>", ":m .+1<CR>==") -- move line up(n)
-- -- map("n", "<A-k>", ":m .-2<CR>==") -- move line down(n)
-- -- map("v", "<A-j>", ":m '>+1<CR>gv=gv") -- move line up(v)
-- -- map("v", "<A-k>", ":m '<-2<CR>gv=gv") -- move line down(v)
-- -- Keybinds to make split navigation easier.
-- --  Use CTRL+<hjkl> to switch between windows
-- --
-- --  See `:help wincmd` for a list of all window commands
-- vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
-- vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
-- vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
-- vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- -- [[ Basic Autocommands ]]
-- --  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- -- vim: ts=2 sts=2 sw=2 et
--
 -- Yank and Paste
vim.api.nvim_set_keymap('n', '<leader>y', '"+y<CR>', { silent = true })
vim.api.nvim_set_keymap('v', '<leader>y', '"+y<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>p', '"+p<CR>', { silent = true })
vim.api.nvim_set_keymap('v', '<leader>p', '"+p<CR>', { silent = true })

-- Page Up / Down and Center Cursor
vim.api.nvim_set_keymap('n', '<C-d>', '<C-d>zz', { silent = true })
vim.api.nvim_set_keymap('n', '<C-u>', '<C-u>zz', { silent = true })

-- Resource
vim.api.nvim_set_keymap('n', '<leader>r', '<cmd>so<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>z', '<cmd>echo "leader z Not mapped yet"<CR>', { silent = true })

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.api.nvim_set_keymap('n', '<Esc>', '<cmd>nohlsearch<CR>', { silent = true })

-- Diagnostic Keymaps
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { desc = 'Go to previous [D]iagnostic message', silent = true })
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', { desc = 'Go to next [D]iagnostic message', silent = true })
vim.api.nvim_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', { desc = 'Show diagnostic [E]rror messages', silent = true })
vim.api.nvim_set_keymap('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', { desc = 'Open diagnostic [Q]uickfix list', silent = true })

-- TIP: Disable arrow keys in normal mode
vim.api.nvim_set_keymap('n', '<left>', '<cmd>echo "Use h to move!!"<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<right>', '<cmd>echo "Use l to move!!"<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<up>', '<cmd>echo "Use k to move!!"<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<down>', '<cmd>echo "Use j to move!!"<CR>', { silent = true })


-- Move line up (n)
vim.api.nvim_set_keymap('n', '<leader>j', ':m .+1<CR>==', { silent = true })
-- Move line down (n)
vim.api.nvim_set_keymap('n', '<leader>k', ':m .-2<CR>==', { silent = true })
-- Move line up (v)
vim.api.nvim_set_keymap('v', '<leader>j', ':m \'>+1<CR>gv=gv', { silent = true })
-- Move line down (v)
vim.api.nvim_set_keymap('v', '<leader>k', ':m \'<-2<CR>gv=gv', { silent = true })
-- Move line up (i)
vim.api.nvim_set_keymap('i', '<leader>j', '<Esc>:m .-2<CR>==gi', { silent = true })
-- Move line down (i)
vim.api.nvim_set_keymap('i', '<leader>k', '<Esc>:m .+1<CR>==gi', { silent = true })
-- Duplicate Line
vim.api.nvim_set_keymap('n', '<Leader>d', ':.t.<CR>', { silent = true }) -- Duplicate line (n)
vim.api.nvim_set_keymap('v', '<Leader>d', ':\'<,\'>t\'>+1<CR>', { silent = true }) -- Duplicate line (v)

-- Split Navigation
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window', silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window', silent = true })
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window', silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window', silent = true })

-- Highlight when Yanking Text
-- vim.api.nvim_create_autocmd('TextYankPost', {
--  desc = 'Highlight when yanking (copying) text',
--  group = 'kickstart-highlight-yank',
--  callback = function()
--    vim.highlight.on_yank()
--  end,
-- })
