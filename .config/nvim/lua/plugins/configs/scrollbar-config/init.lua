require("scrollbar").setup({
  handle = {
    color = "#3C3F50",
  },
  handlers = {
    cursor = true,
    diagnostic = true,
    gitsigns = true, -- Requires gitsigns
    handle = true,
    search = false, -- Requires hlslens
  },
})
