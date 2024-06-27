return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  opts = {
    options = {
      mode = "buffers",
      offsets = { { filetype = "neo-tree" } },
      separator_style = "padded slant",
    },
  },
}
