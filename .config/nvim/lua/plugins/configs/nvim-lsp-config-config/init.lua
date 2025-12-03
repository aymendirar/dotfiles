if vim.opt.diff:get() then
  return
end

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }

  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
  vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set("n", "<space>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set("n", "<space>r", vim.lsp.buf.rename, bufopts)
  vim.keymap.set("n", "<space>a", vim.lsp.buf.code_action, bufopts)

  require("lsp_signature").on_attach({
    bind = true, -- This is mandatory, otherwise border config won't get registered.
    handler_opts = {
      border = "rounded",
    },
  }, bufnr)
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 50,
}
vim.lsp.config("astro", {
  on_attach = on_attach,
  flags = lsp_flags,
})
vim.lsp.config("clangd", {
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "hpp" },
  on_attach = on_attach,
  flags = lsp_flags,
})
vim.lsp.config("elp", {
  on_attach = on_attach,
  flags = lsp_flags,
})
vim.lsp.config("gopls", {
  on_attach = on_attach,
  flags = lsp_flags,
  settings = {
    gopls = {
      buildFlags = { "-mod=readonly" },
    },
  },
})
vim.lsp.config("hls", {
  on_attach = on_attach,
  flags = lsp_flags,
})
vim.lsp.config("html", {
  on_attach = on_attach,
  flags = lsp_flags,
})
vim.lsp.config("jdtls", {
  on_attach = on_attach,
  flags = lsp_flags,
})
vim.lsp.config("marksman", {
  on_attach = on_attach,
  flags = lsp_flags,
})
vim.lsp.config("pyright", {
  on_attach = on_attach,
  flags = lsp_flags,
})
vim.lsp.config("racket_langserver", {
  on_attach = on_attach,
  flags = lsp_flags,
})
vim.lsp.config("sorbet", {
  on_attach = on_attach,
  flags = lsp_flags,
})
vim.lsp.config("ruby_lsp", {
  on_attach = on_attach,
  flags = lsp_flags,
  cmd = { "bundle", "exec", "ruby-lsp" },
  filetypes = { "ruby" },
  root_dir = require("lspconfig").util.root_pattern("Gemfile", ".git"),
  init_options = {
    formatter = "auto",
  },
})
vim.lsp.config("terraformls", {
  filetypes = { "terraform", "tf", "terraform-vars" },
  on_attach = on_attach,
  flags = lsp_flags,
  root_dir = function(fname)
    -- Only activate in directories that actually contain terraform files
    return require("lspconfig").util.root_pattern("*.tf", ".terraform")(fname)
  end,
})
vim.lsp.config("rust_analyzer", {
  on_attach = on_attach,
  flags = lsp_flags,
  -- Server-specific settings...
  settings = {
    ["rust_analyzer"] = {
      assist = {
        importGranularity = "module",
        importPrefix = "self",
      },
      cargo = {
        loadOutDirsFromCheck = true,
      },
      procMacro = {
        enable = true,
      },
    },
  },
})
vim.lsp.config("lua_ls", {
  on_attach = on_attach,
  flags = lsp_flags,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim", "use" },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
})
vim.lsp.config("nginx_language_server", {
  on_attach = on_attach,
  flags = lsp_flags,
})
vim.lsp.config("protols", {
  on_attach = on_attach,
  flags = lsp_flags,
})
vim.lsp.config("protols", {
  on_attach = on_attach,
  flags = lsp_flags,
})
vim.lsp.config("ts_ls", {
  init_options = { hostInfo = "neovim", maxTsServerMemory = 8192 },
  on_attach = on_attach,
  flags = lsp_flags,
})
vim.lsp.config("yamlls", {
  on_attach = on_attach,
  flags = lsp_flags,
})
