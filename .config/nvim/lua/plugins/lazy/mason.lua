return {
  {
    "williamboman/mason.nvim",
    event = "VeryLazy",
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
    event = "VeryLazy",
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
  },
}
