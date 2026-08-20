local set = vim.opt
local raw_set = vim.api.nvim_command
local window = vim.wo

-- lua settings
set.guicursor = ""
set.termguicolors = true
-- give floating windows a border unless a plugin explicitly chooses another style
set.winborder = "rounded"
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
set.scrollbind = false
set.fileencoding = "utf-8"

set.cursorline = false

set.hidden = true

-- raw settings

raw_set("set clipboard=unnamedplus")
raw_set("set foldlevel=99")
raw_set("set signcolumn=yes")
raw_set("set laststatus=3")
raw_set("set noreadonly")

-- fold settings; the native lua foldexpr replaced nvim_treesitter#foldexpr() in
-- 0.10 and avoids a vimscript round trip per line. set globally rather than on
-- vim.wo so every window gets it, not just the first one
set.foldmethod = "expr"
set.foldexpr = "v:lua.vim.treesitter.foldexpr()"

vim.api.nvim_set_hl(0, "LineNr", { fg = "#737994" })

vim.g.maplocalleader = ","

vim.cmd(":highlight VertSplit guifg=#ffffff")
vim.cmd(":set fillchars+=vert:┃")
vim.api.nvim_set_hl(0, "LineNr", { fg = "#737994" })
vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { fg = "#737994" })

-- over ssh there is no local clipboard tool worth reaching for: without a
-- display the provider silently fails, and with x11 forwarding every yank
-- round trips. osc52 hands the copy to the terminal emulator instead.
-- paste stays on the unnamed register because osc52 reads require the terminal
-- to allow clipboard queries, and nvim blocks waiting on ones that never answer
if vim.env.SSH_TTY then
  local osc52 = require("vim.ui.clipboard.osc52")
  local function paste()
    return vim.split(vim.fn.getreg("") or "", "\n")
  end

  vim.g.clipboard = {
    name = "OSC 52",
    copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
    paste = { ["+"] = paste, ["*"] = paste },
  }
end
