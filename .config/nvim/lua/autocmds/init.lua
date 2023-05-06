-- local api = vim.api

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = { "*.rkt", "*.rktl", "*.rktd" },
  command = "set filetype=racket",
})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead", "BufReadPost" }, {
  pattern = "*.scrbl",
  command = "set filetype=racket",
})
-- auto format on save, but it's kinda annoying
-- vim.cmd([[
--   augroup FormatAutogroup
--     autocmd!
--     autocmd BufWritePost * FormatWrite
--   augroup END
-- ]])
