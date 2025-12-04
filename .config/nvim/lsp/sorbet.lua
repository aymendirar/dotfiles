-- Ruby Sorbet Type Checker configuration
return {
  cmd = { "srb", "tc", "--lsp" },
  filetypes = { "ruby" },
  root_markers = { "Gemfile", ".git" },
}
