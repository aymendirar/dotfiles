require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "astro",
    "c",
    "cpp",
    "dockerfile",
    "go",
    "html",
    "lua",
    "markdown",
    "python",
    "rust",
    "sql",
    "tsx",
    "typescript",
  },
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  },
  autotag = {
    enable = true,
  },
})
