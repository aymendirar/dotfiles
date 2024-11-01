vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = { "*.rkt", "*.rktl", "*.rktd" },
  command = "set filetype=racket",
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead", "BufReadPost" }, {
  pattern = "*.scrbl",
  command = "set filetype=racket",
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead", "BufReadPost" }, {
  pattern = "*.rbi",
  command = "set filetype=ruby",
})
