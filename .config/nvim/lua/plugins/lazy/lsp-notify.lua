return {
  "mrded/nvim-lsp-notify",
  dependencies = { "rcarriga/nvim-notify" },
  event = "VeryLazy",
  config = function()
    require("lsp-notify").setup({
      notify = require("notify"),
    })
  end,
}
