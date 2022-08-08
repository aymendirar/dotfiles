vim.g.neoformat_enabled_yaml = { "prettier" } -- avoids EPIPE error i was running into with yaml files
vim.cmd([[
  augroup fmt
    autocmd!
    autocmd BufWritePre * undojoin | Neoformat
  augroup END
]])
