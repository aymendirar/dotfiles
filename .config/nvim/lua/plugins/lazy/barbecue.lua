-- navic can't support multiple LSPs on the same buffer, so silence the errors
vim.g.navic_silence = true

return {
  "utilyre/barbecue.nvim",
  event = "VeryLazy",
  name = "barbecue",
  version = "*",
  dependencies = {
    "SmiteshP/nvim-navic",
    "nvim-tree/nvim-web-devicons", -- optional dependency
  },
  opts = {
    -- configurations go here
  },
}
