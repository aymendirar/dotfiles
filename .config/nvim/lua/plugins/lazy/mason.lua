return {
  {
    "williamboman/mason.nvim",
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
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "clangd",
        "elp",
        "gopls",
        "jdtls",
        "marksman",
        "pyright",
        "lua_ls",
        "ts_ls",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
  }
}
