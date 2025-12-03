return {
  "akinsho/bufferline.nvim",
  -- version = "v3.*",
  event = "VeryLazy",
  dependencies = "nvim-tree/nvim-web-devicons",
  opts = {
    options = {
      mode = "buffers",
    },
  },
  config = function()
    require("bufferline").setup({
      highlights = require("catppuccin.special.bufferline").get_theme(),
    })
  end,
}
