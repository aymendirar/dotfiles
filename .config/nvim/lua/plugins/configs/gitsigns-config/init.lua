require("gitsigns").setup({
  current_line_blame = true,
  current_line_blame_opts = {
    delay = 50,
  },
})

require("scrollbar.handlers.gitsigns").setup()
