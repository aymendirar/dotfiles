-- LspAttach autocmd for nvim > 0.11
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local bufnr = ev.buf

    -- Enable completion triggered by <c-x><c-o>
    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- Buffer-specific LSP keymaps
    local bufopts = { noremap = true, silent = true, buffer = bufnr }

    -- Diagnostic keymaps
    vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, bufopts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, bufopts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, bufopts)
    vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, bufopts)

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

    -- Setup autocomplete
    -- local client = vim.lsp.get_client_by_id(ev.data.client_id)
    -- if client and client:supports_method("textDocument/completion") then
    --   vim.o.completeopt = "fuzzy,menuone,popup,noinsert,noselect"
    --   vim.o.pumheight = 7
    --   vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    -- end

    -- Setup lsp_signature for this buffer
    require("lsp_signature").on_attach({
      bind = true,
      handler_opts = {
        border = "rounded",
      },
    }, bufnr)
  end,
})

-- vim.api.nvim_create_autocmd("BufEnter", {
--   pattern = { "*.ts", "*.go", "*.tf", "*.rb" },
--   command = "e",
-- })

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = { "*.rkt", "*.rktl", "*.rktd" },
  command = "set filetype=racket",
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead", "BufReadPost" }, {
  pattern = "*.scrbl",
  command = "set filetype=racket",
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead", "BufReadPost" }, {
  pattern = "*.rbi",
  command = "set filetype=ruby",
})

-- Open help window in a vertical split to the right.
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = vim.api.nvim_create_augroup("help_window_right", {}),
  pattern = { "*.txt" },
  callback = function()
    if vim.o.filetype == "help" then
      vim.cmd.wincmd("L")
      vim.cmd([[vertical resize 100]])
    end
  end,
})

-- vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
--   pattern = { "*" },
--   callback = function()
--     vim.cmd([[let pos = getpos(".")]])
--     vim.cmd([[normal! zz]])
--     vim.cmd([[call setpos(".", pos)]])
--   end,
-- })
