local colors = require("catppuccin.palettes.frappe")

require("scrollbar").setup({
  handle = {
    color = colors.surface0,
  },
  handlers = {
    cursor = true,
    diagnostic = true,
    gitsigns = true, -- Requires gitsigns
    handle = true,
    search = false, -- Requires hlslens
  },
})
