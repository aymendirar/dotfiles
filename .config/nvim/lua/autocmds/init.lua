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

-- Open help window in a vertical split to the right.
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = vim.api.nvim_create_augroup("help_window_right", {}),
  pattern = { "*.txt" },
  callback = function()
    if vim.o.filetype == "help" then
      vim.cmd.wincmd("L")
      vim.cmd([[vertical resize 100]])
    end
  end,
})

vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
  pattern = { "*" },
  callback = function()
    vim.cmd([[let pos = getpos(".")]])
    vim.cmd([[normal! zz]])
    vim.cmd([[call setpos(".", pos)]])
  end,
})
