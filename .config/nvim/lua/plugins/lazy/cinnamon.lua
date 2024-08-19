return {
  "declancm/cinnamon.nvim",
  version = "*", -- use latest release
  opts = {
    -- change default options here
  },
  init = function()
    local cinnamon = require("cinnamon")

    cinnamon.setup()

    -- Centered scrolling:
    vim.keymap.set("n", "<C-U>", function()
      cinnamon.scroll("<C-U>zz")
    end)
    vim.keymap.set("n", "<C-D>", function()
      cinnamon.scroll("<C-D>zz")
    end)

    -- LSP:
    vim.keymap.set("n", "gd", function()
      cinnamon.scroll(vim.lsp.buf.definition)
    end)
    vim.keymap.set("n", "gD", function()
      cinnamon.scroll(vim.lsp.buf.declaration)
    end)
  end,
}
