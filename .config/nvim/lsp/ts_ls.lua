-- TypeScript/JavaScript Language Server configuration
return {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
  init_options = {
    hostInfo = "neovim",
    maxTsServerMemory = 8192,
  },
}
