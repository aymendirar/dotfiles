-- LSP Global Configuration
-- Individual server configs are automatically loaded from lsp/<server>.lua files

if vim.opt.diff:get() then
  return
end

-- Set global root markers for all LSP clients
-- vim.lsp.config("*", {
--   root_markers = { ".git" },
-- })

-- Enable all configured LSP servers
vim.lsp.enable({
  "astro",
  "clangd",
  "elp",
  "gopls",
  "hls",
  "html",
  "jdtls",
  "lua_ls",
  "marksman",
  "nginx_language_server",
  "protols",
  "pyright",
  "racket_langserver",
  -- "ruby_lsp",
  "rust_analyzer",
  "sorbet",
  "terraformls",
  "ts_ls",
  "yamlls",
})
