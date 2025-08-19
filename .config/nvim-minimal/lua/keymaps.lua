local opts = { noremap = true, silent = true }

local keymap = vim.api.nvim_set_keymap

keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

keymap("n", "<leader>pv", ":Lex 30<cr>", opts)

keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

keymap("n", "<TAB>", ":bnext<CR>", opts)
keymap("n", "<S-TAB>", ":bprevious<CR>", opts)

keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.format{}<cr>", opts)

keymap("n", "<leader>w", ":w<CR>", opts)
keymap("n", "<leader>q", ":q<CR>", opts)
keymap("n", "<leader>c", ":bd<CR>", opts)

keymap("n", "<leader>h", ":nohlsearch<CR>", opts)

keymap("n", "J", "mzJ`z", opts)
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)
keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)

keymap("n", "<leader>y", '"+y', opts)
keymap("v", "<leader>y", '"+y', opts)
keymap("n", "<leader>Y", '"+Y', opts)

keymap("n", "<leader>d", '"_d', opts)
keymap("v", "<leader>d", '"_d', opts)

keymap("n", "Q", "<nop>", opts)

keymap("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], opts)
keymap("n", "<leader>X", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end, opts)

-- View messages and logs
vim.keymap.set("n", "<leader>m", "<cmd>messages<CR>", opts)
keymap("n", "<leader>lm", ":Mason<CR>", opts)
keymap("n", "<leader>ll", ":LspLog<CR>", opts)
keymap("n", "<leader>ml", ":MasonLog<CR>", opts)

-- Close floating windows
vim.keymap.set("n", "<Esc>", function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= '' then
      vim.api.nvim_win_close(win, false)
    end
  end
end, opts)

-- LSP info commands (correct commands for Neovim 0.11)
vim.keymap.set("n", "<leader>li", function()
  vim.cmd("checkhealth lsp")
end, opts)
vim.keymap.set("n", "<leader>lr", function()
  vim.cmd("LspRestart")
end, opts)
vim.keymap.set("n", "<leader>lc", function()
  local clients = vim.lsp.get_clients()
  if #clients == 0 then
    print("No LSP clients attached")
  else
    for _, client in ipairs(clients) do
      print("LSP: " .. client.name .. " (id: " .. client.id .. ")")
    end
  end
end, opts)

-- Focus floating window
vim.keymap.set("n", "<C-w>f", function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= '' and config.focusable ~= false then
      vim.api.nvim_set_current_win(win)
      return
    end
  end
  print("No focusable floating window found")
end, { desc = "Focus floating window" })

-- Telescope LSP commands (if you want to add telescope later)
-- keymap("n", "<leader>fs", ":Telescope lsp_document_symbols<CR>", opts)
-- keymap("n", "<leader>fS", ":Telescope lsp_workspace_symbols<CR>", opts)
-- keymap("n", "<leader>fr", ":Telescope lsp_references<CR>", opts)