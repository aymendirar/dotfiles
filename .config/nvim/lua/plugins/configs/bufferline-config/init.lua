vim.opt.termguicolors = true
require("bufferline").setup({
  options = {
    mode = "tabs",
    offsets = { { filetype = "neo-tree" } },
    separator_style = "thin",
  },
})
