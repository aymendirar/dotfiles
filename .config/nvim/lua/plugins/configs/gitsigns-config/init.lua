require("gitsigns").setup({
  current_line_blame = true,
  current_line_blame_opts = {
    delay = 400,
  },
})

vim.api.nvim_command("highlight link GitSignsCurrentLineBlame Insert")
