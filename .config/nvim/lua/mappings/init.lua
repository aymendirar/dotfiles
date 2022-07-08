local map = vim.api.nvim_set_keymap
local options = { noremap = true, silent = true }

vim.g.mapleader = " "

-- insert mode remappings
map("i", "jj", "<Esc>", options)

-- normal mode remappings
-- movement
map("n", "<leader>h", "<C-w>h", options)
map("n", "<leader>l", "<C-w>l", options)
map("n", "<leader>j", "<C-w>j", options)
map("n", "<leader>k", "<C-w>k", options)

map("n", "<leader>u", ":BufferLineCyclePrev<CR>", options)
map("n", "<leader>i", ":BufferLineCycleNext<CR>", options)

map("n", "<leader>n", "^", options)
map("n", "<leader>w", ":w<CR>", options)
map("n", "<leader>a", ":wa<CR>", options)
map("n", "<leader>q", ":q<CR>", options)
map("n", "Y", "y$", options)

-- plugin remappings
map("n", "<leader>t", ":NeoTreeFocusToggle<CR>", options)
map("n", "<leader>tr", ":NeoTreeReveal<CR>", options)

map("n", "<leader>p", ":Telescope find_files<CR>", options)
map("n", "<leader>s", ":Telescope live_grep<CR>", options)

map("n", "<leader>g", ":LazyGit<CR>", options)

map("n", "<leader>e", ":lua vim.diagnostic.open_float(nil, {focus=false})<CR>", options)
