-- local api = vim.api
--
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = { "*.rkt", "*.rktl", "*.rktd" },
  command = "set filetype=racket",
})
