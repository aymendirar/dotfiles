require("gitsigns").setup({
  current_line_blame = true,
  current_line_blame_opts = {
    delay = 50,
  },
})

vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { fg = "#a5adce", italic = true, blend = 100 })
