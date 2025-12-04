return {
  "mhartington/formatter.nvim",
  event = "VeryLazy",
  config = function()
    local default_filetype_configs = require("formatter.filetypes")
    local defaults = require("formatter.defaults")
    local util = require("formatter.util")

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
        javascript = default_filetype_configs.javascript.prettier,
        javascriptreact = default_filetype_configs.javascriptreact.prettier,
        json = default_filetype_configs.json.prettier,
        typescript = default_filetype_configs.typescript.prettier,
        typescriptreact = default_filetype_configs.typescriptreact.prettier,
        rust = default_filetype_configs.rust.rustfmt,
        markdown = default_filetype_configs.markdown.prettier,
        haskell = default_filetype_configs.haskell.stylish_haskell,
        go = default_filetype_configs.go.gofmt,
        ruby = util.copyf(defaults.prettier),
        yaml = util.copyf(defaults.prettier),

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
  end,
}
