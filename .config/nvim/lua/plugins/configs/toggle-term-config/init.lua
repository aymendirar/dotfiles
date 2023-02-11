require("toggleterm").setup({
  direction = 'float',
})

function _G.set_terminal_keymaps()
  local opts = {buffer = 0}
  vim.keymap.set('t', '<C-`>', [[<C-\><C-n>:ToggleTerm<CR>]], opts)
  vim.keymap.set('t', '<Esc>', [[<C-\><C-n>:ToggleTerm<CR>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
