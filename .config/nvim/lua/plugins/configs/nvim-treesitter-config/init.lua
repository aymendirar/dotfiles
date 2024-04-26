require("nvim-treesitter.configs").setup({
  ensure_installed = "all",
  highlight = {
    enable = true,
  },
  indent = {
    enable = true, -- this is hit or miss
  },
  autotag = {
    enable = true,
  },
})
