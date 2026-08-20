return {
  "akinsho/toggleterm.nvim",
  version = "*",
  opts = {
    highlights = {
      FloatBorder = { fg = "#ffffff" },
    },
    float_opts = {
      border = "single",
      -- like `size`, width, height, row, and col can be a number or function which is passed the current terminal
      width = 200,
      height = 50,
      title_pos = "center",
    },
  },
}
