return {
  {
    "mason-org/mason.nvim",
    build = ":MasonUpdate",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "clangd",
        "gopls",
        "lua_ls",
        "marksman",
        "rubocop",
        "ruby_lsp",
        "sorbet",
        "terraformls",
        "ts_ls",
        "yamlls",
      },
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
    },
  },
  {
    "stevearc/dressing.nvim",
    opts = {},
  },
}
