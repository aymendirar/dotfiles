-- Haskell Language Server configuration
return {
  cmd = { "haskell-language-server-wrapper", "--lsp" },
  filetypes = { "haskell", "lhaskell" },
  root_markers = { "hie.yaml", "stack.yaml", "cabal.project", "package.yaml", ".git" },
}
