if vim.opt.diff:get() then
  return
end

local cmp = require("cmp")

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "vsnip" }, -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = "buffer" },
  }),
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
  sources = cmp.config.sources({
    { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = "buffer" },
  }),
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})

-- Setup lspconfig.
local capabilities = function()
  require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
end

-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
vim.lsp.config("clangd", {
  capabilities = capabilities,
})
vim.lsp.config("elp", {
  capabilities = capabilities,
})
vim.lsp.config("gopls", {
  capabilities = capabilities,
})
vim.lsp.config("hls", {
  capabilities = capabilities,
})
vim.lsp.config("html", {
  capabilities = capabilities,
})
vim.lsp.config("jdtls", {
  capabilities = capabilities,
})
vim.lsp.config("marksman", {
  capabilities = capabilities,
})
vim.lsp.config("pyright", {
  capabilities = capabilities,
})
vim.lsp.config("pbls", {
  capabilities = capabilities,
})
vim.lsp.config("racket_langserver", {
  capabilities = capabilities,
})
vim.lsp.config("sorbet", {
  capabilities = capabilities,
})
-- vim.lsp.config("ruby_lsp",{
--   capabilities = capabilities,
-- })
vim.lsp.config("rust_analyzer", {
  capabilities = capabilities,
})
vim.lsp.config("lua_ls", {
  capabilities = capabilities,
})
vim.lsp.config("nginx_language_server", {
  capabilities = capabilities,
})
vim.lsp.config("protols", {
  capabilities = capabilities,
})
vim.lsp.config("terraformls", {
  capabilities = capabilities,
})
vim.lsp.config("ts_ls", {
  capabilities = capabilities,
  init_options = {
    preferences = {
      disableSuggestions = false,
    },
  },
})
vim.lsp.config("yamlls", {
  capabilities = capabilities,
})
