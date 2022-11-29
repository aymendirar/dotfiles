vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha

require("catppuccin").setup({
  styles = {
    comments = { "italic" },
    conditionals = {},
    loops = {},
    functions = { "italic", "bold" },
    keywords = { "italic", "bold" },
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = { "italic", "bold" },
    operators = {},
  },
  custom_highlights = {
    TSParameter = { style = { "bold" } },
  },
})

vim.cmd([[colorscheme catppuccin]])
vim.cmd(":highlight VertSplit guifg=#ffffff")
