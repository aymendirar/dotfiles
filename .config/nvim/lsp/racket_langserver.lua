-- Racket Language Server configuration
return {
  cmd = { "racket", "--lib", "racket-langserver" },
  filetypes = { "racket", "scheme" },
  root_markers = { "info.rkt", ".git" },
}
