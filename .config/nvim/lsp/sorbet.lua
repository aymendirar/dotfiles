-- Ruby Sorbet Type Checker configuration
return {
  cmd = { "bundle", "exec", "srb", "tc", "--lsp" },
  filetypes = { "ruby" },
  root_markers = { "Gemfile", ".git" },
}
