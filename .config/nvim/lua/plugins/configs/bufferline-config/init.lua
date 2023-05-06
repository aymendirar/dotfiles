vim.opt.termguicolors = true
require("bufferline").setup({
  highlights = require("catppuccin.groups.integrations.bufferline").get(),
  options = {
    mode = "buffers",
    offsets = { { filetype = "neo-tree" } },
    separator_style = "padded slant",
  },
})
