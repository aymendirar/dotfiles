require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "astro",
    "bash",
    "c",
    "cpp",
    "dockerfile",
    "go",
    "html",
    "lua",
    "markdown",
    "python",
    "racket",
    "rust",
    "sql",
    "tsx",
    "typescript",
  },
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
