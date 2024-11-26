return {
  "petertriho/nvim-scrollbar",
  config = function()
    require("scrollbar").setup({
      handle = {
        color = "#383A4C",
      },
    })
    require("scrollbar.handlers.gitsigns").setup()
  end,
}
