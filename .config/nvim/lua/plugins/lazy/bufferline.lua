return {
  "akinsho/bufferline.nvim",
  -- version = "v3.*",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin" },
  opts = {
    options = {
      mode = "buffers",
    },
  },
  config = function()
    require("bufferline").setup({
      highlights = require("catppuccin.groups.integrations.bufferline").get()
    })
  end,
}
