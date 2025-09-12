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
require("lspconfig")["clangd"].setup({
  capabilities = capabilities,
})
require("lspconfig")["elp"].setup({
  capabilities = capabilities,
})
require("lspconfig")["gopls"].setup({
  capabilities = capabilities,
})
require("lspconfig")["hls"].setup({
  capabilities = capabilities,
})
require("lspconfig")["html"].setup({
  capabilities = capabilities,
})
require("lspconfig")["jdtls"].setup({
  capabilities = capabilities,
})
require("lspconfig")["marksman"].setup({
  capabilities = capabilities,
})
require("lspconfig")["pyright"].setup({
  capabilities = capabilities,
})
require("lspconfig")["pbls"].setup({
  capabilities = capabilities,
})
require("lspconfig")["racket_langserver"].setup({
  capabilities = capabilities,
})
require("lspconfig")["sorbet"].setup({
  capabilities = capabilities,
})
require("lspconfig")["ruby_lsp"].setup({
  capabilities = capabilities,
})
require("lspconfig")["rust_analyzer"].setup({
  capabilities = capabilities,
})
require("lspconfig")["lua_ls"].setup({
  capabilities = capabilities,
})
require("lspconfig")["nginx_language_server"].setup({
  capabilities = capabilities,
})
require("lspconfig")["protols"].setup({
  capabilities = capabilities,
})
require("lspconfig")["terraformls"].setup({
  capabilities = capabilities,
})
require("lspconfig")["ts_ls"].setup({
  capabilities = capabilities,
  init_options = {
    preferences = {
      disableSuggestions = false,
    },
  },
})
require("lspconfig")["yamlls"].setup({
  capabilities = capabilities,
})
