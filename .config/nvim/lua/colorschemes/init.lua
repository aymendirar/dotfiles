vim.g.catppuccin_flavour = "frappe" -- latte, frappe, macchiato, mocha

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
  dim_inactive = {
    enabled = true,
    shade = "dark",
    percentage = 0.15,
  },
  color_overrides = {
    latte = {
      base = "#EDEFF3",
    },
  },
  custom_highlights = {
    TSParameter = { style = { "bold" } },
  },
  integrations = {
    lsp_saga = true,
    treesitter = true,
    cmp = true,
    gitgutter = false,
    gitsigns = true,
    ts_rainbow = true,
    neotree = {
      enabled = false,
      show_root = true,
      transparent_panel = false,
    },
    native_lsp = {
      enabled = true,
      virtual_text = {
        errors = { "italic" },
        hints = { "italic" },
        warnings = { "italic" },
        information = { "italic" },
      },
      underlines = {
        errors = { "underline" },
        hints = { "underline" },
        warnings = { "underline" },
        information = { "underline" },
      },
    },
    indent_blankline = {
      enabled = true,
      colored_indent_levels = false,
    },
  },
})

vim.cmd([[colorscheme catppuccin]])
vim.cmd(":highlight VertSplit guifg=#ffffff")
vim.cmd(":set fillchars+=vert:┃")
