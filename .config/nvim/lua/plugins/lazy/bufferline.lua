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
  init = function()
    local bufline = require("catppuccin.groups.integrations.bufferline")
    bufline.get = bufline.get_theme
  end,
}
