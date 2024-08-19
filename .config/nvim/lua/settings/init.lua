local set = vim.opt
local raw_set = vim.api.nvim_command
local window = vim.wo

-- lua settings
set.guicursor = ""
set.termguicolors = true
set.hidden = true
set.number = true
set.tabstop = 2
set.shiftwidth = 2
set.autoindent = true
set.expandtab = true

set.hlsearch = true
set.incsearch = true
set.ignorecase = true
set.smartcase = true

set.splitbelow = true
set.splitright = true
set.wrap = true
set.mouse = "a"

set.scrolloff = 12
set.fileencoding = "utf-8"

set.cursorline = false

set.hidden = true

-- raw settings
raw_set("set clipboard+=unnamedplus") -- use system clipboard
raw_set("set foldlevel=99")
raw_set("set signcolumn=yes")
raw_set("set laststatus=3")

-- window settings
window.foldmethod = "expr"
window.foldexpr = "nvim_treesitter#foldexpr()"

vim.api.nvim_set_hl(0, "LineNr", { fg = "#737994" })

vim.g.maplocalleader = ","
