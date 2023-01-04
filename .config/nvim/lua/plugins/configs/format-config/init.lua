local default_filetype_configs = require("formatter.filetypes")

require("formatter").setup({
  -- Enable or disable logging
  logging = true, -- Enable or disable logging
  -- Set the log level
  log_level = vim.log.levels.WARN,
  -- All formatter configurations are opt-in
  filetype = {
    lua = default_filetype_configs.lua.stylua,
    c = default_filetype_configs.c.clangformat,
    cpp = default_filetype_configs.cpp.clangformat,
    python = default_filetype_configs.python.black,
    html = default_filetype_configs.html.prettier,
    javascript = default_filetype_configs.javascript.pretier,
    javascriptreact = default_filetype_configs.javascriptreact.prettier,
    json = default_filetype_configs.json.prettier,
    typescript = default_filetype_configs.typescript.prettier,
    typescriptreact = default_filetype_configs.typescriptreact.prettier,
    rust = default_filetype_configs.rust.rustfmt,

    -- Use the special "*" filetype for defining formatter configurations on
    -- any filetype
    ["*"] = {
      -- "formatter.filetypes.any" defines default configurations for any
      -- filetype
      function()
        return { exe = "sed", args = { "-i", "''", "'s/[	 ]*$//'" } }
      end,
    },
  },
})

-- vim.cmd([[
--   augroup FormatAutogroup
--     autocmd!
--     autocmd BufWritePost * FormatWrite
--   augroup END
-- ]])
