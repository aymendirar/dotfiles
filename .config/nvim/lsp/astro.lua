-- Astro Language Server configuration
return {
  cmd = { "astro-ls", "--stdio" },
  filetypes = { "astro" },
  root_markers = { "package.json", "astro.config.mjs", ".git" },
}
