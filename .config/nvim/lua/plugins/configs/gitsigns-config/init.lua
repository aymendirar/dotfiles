require("gitsigns").setup({
  current_line_blame = true,
  current_line_blame_opts = {
    delay = 400,
  },
})

vim.highlight.link("GitSignsCurrentLineBlame", "Comment", true)
