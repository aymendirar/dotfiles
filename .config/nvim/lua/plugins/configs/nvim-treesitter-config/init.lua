require("nvim-treesitter.configs").setup({
  ensure_installed = "all",
  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (or "all")
  ignore_install = {},

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/t
  highlight = {
    enable = true,
    disable = {}, -- list of language that will be disabled
  },
  indent = {
    enable = true, -- this is hit or miss
  },
})
