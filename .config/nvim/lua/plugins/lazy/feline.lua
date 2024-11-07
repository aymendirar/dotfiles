return {
  "freddiehaddad/feline.nvim",
  opts = {},
  config = function(_, opts)
    local ctp_feline = require("catppuccin.groups.integrations.feline")

    ctp_feline.setup()

    require("feline").setup({
      components = ctp_feline.get(),
    })
    -- require("feline").winbar.setup() -- to use winbar
    -- require("feline").statuscolumn.setup() -- to use statuscolumn

    -- require("feline").use_theme() -- to use a custom theme
  end,
}
