require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})

require("mason-lspconfig").setup({
  ensure_installed = { "clangd", "html", "marksman", "pyright", "rust_analyzer", "lua_ls", "tsserver" },
})
