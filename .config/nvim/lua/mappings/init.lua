local map = vim.api.nvim_set_keymap
local options = { noremap = true, silent = true }

vim.g.mapleader = " "

-- visual mode remappings
map("v", "<S-Tab>", "<", options)
map("v", "<leader>sw", '<esc><cmd>lua require("spectre").open_visual()<CR>', {
  desc = "Search current word",
})

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- insert mode remappings
map("i", "jj", "<Esc>", options)
map("i", "JJ", "<Esc>", options)
map("i", "<S-Tab>", "<C-d>", options)

-- normal mode remappings
-- movement
-- map("n", "<S-tab>", "<<", options)
-- map("n", "<tab>", ">>", options) this messes w <C-I>, <C-O> :(
map("n", "<leader>h", "<C-w>h", options)
map("n", "<leader>l", "<C-w>l", options)
map("n", "<leader>j", "<C-w>j", options)
map("n", "<leader>k", "<C-w>k", options)

map("n", "<leader>qt", ":tabclose<CR>", options)

map("n", "<leader>n", "^", options)
map("n", "<leader>w", ":w<CR>", options)
map("n", "<leader>a", ":wa<CR>", options)
map("n", "<leader>q", ":q<CR>", options)
map("n", "Y", "y$", options)
map("n", "<leader>cp", ":let @+ = expand('%:p')<CR>", options) -- copy full file path

vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<leader>res", "<cmd>LspRestart<cr>")

-- plugin remappings
map("n", "<leader>u", ":BufferLineCyclePrev<CR>", options)
map("n", "<leader>i", ":BufferLineCycleNext<CR>", options)
map("n", "<leader>ql", ":BufferLineCloseRight<CR>:e<CR>", options)
map("n", "<leader>qh", ":BufferLineCloseLeft<CR>:e<CR>", options)
map("n", "<leader>qx", ":BufferLineCloseLeft<CR>:e<CR>:BufferLineCloseRight<CR>:e<CR>", options)
map("n", "<C-h>", ":BufferLineMovePrev<CR>", options)
map("n", "<C-l>", ":BufferLineMoveNext<CR>", options)

map("n", "<leader>ts", ":Neotree toggle reveal<CR>", options)
map("n", "<leader>tr", ":Neotree reveal<CR>", options)

map("n", "<leader>p", ':lua require"telescope.builtin".find_files({ hidden = true })<CR>', options)
map("n", "<leader>d", ':lua require"telescope.builtin".diagnostics()<CR>', options)

map("n", "<leader>lg", ":LazyGit<CR>", options)
map("n", "<leader>gd", ":DiffviewOpen<CR>", options)
map("n", "<leader>qg", ":DiffviewClose<CR>", options)
map("n", "<leader>qo", ":DiffviewClose<CR>", options)
map("n", "<leader>o", "", {
  noremap = true,
  silent = true,
  callback = function()
    vim.cmd([[let $currentPath=@%]])
    vim.cmd([[DiffviewClose]])
    vim.cmd([[e $currentPath]])
  end,
})

map("n", "<leader>e", ":lua vim.diagnostic.open_float(nil, {focus=false})<CR>", options)

map("n", "<leader>dl", ":DistantLaunch ssh://thetis.students.cs.ubc.ca<CR>", options)
map("n", "<leader>doh", ":DistantOpen /home/a/adirar01<CR>", options)

map("n", "<leader>gl", ":GitConflictListQf<CR>", options)
map("n", "<leader>gn", ":GitConflictNextConflict<CR>", options)
map("n", "<leader>gp", ":GitConflictPrevConflict<CR>", options)
map("n", "<leader>gt", ":GitConflictChooseTheirs<CR>", options)
map("n", "<leader>go", ":GitConflictChooseOurs<CR>", options)
map("n", "<leader>gm", ":GitConflictChooseBoth<CR>", options)

map("n", "<leader>gi", ":GuessIndent<CR>", options)
map("n", "<leader>fw", ":FormatWrite<CR>", options)

map("n", "<leader>tb", ":TroubleToggle<CR>", options)

map("n", "<leader>sp", '<cmd>lua require("spectre").open()<CR><cmd>vertical resize 100<CR>', {
  desc = "Open Spectre",
})
map("n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
  desc = "Search current word",
})

map("n", "<leader>tn", ":Telescope neoclip o<CR>", options)

map("n", "<leader>df", "<cmd>DevdocsFetch<CR>", options)
map("n", "<leader>du", "<cmd>DevdocsUninstall<CR>", options)
map("n", "<leader>di", "<cmd>DevdocsInstall<CR>", options)
map("n", "<leader>do", "<cmd>DevdocsOpen<CR>", options)
