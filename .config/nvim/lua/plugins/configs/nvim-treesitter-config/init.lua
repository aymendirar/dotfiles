require("nvim-treesitter.configs").setup({
  ensure_installed = "all",
  highlight = {
    enable = true,
    disable = { "latex" }, -- list of language that will be disabled
  },
  indent = {
    enable = true, -- this is hit or miss
  },
})
