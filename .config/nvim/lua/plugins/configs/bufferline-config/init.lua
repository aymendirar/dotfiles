vim.opt.termguicolors = true
require("bufferline").setup({
  options = {
    mode = "buffers",
    offsets = { { filetype = "neo-tree" } },
    separator_style = "padded slant",
  },
})
