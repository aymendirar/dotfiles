local actions = require("telescope.actions")
require("telescope").setup({
  defaults = {
    mappings = {
      n = {
        ["<C-t>"] = actions.select_tab,
        ["<C-s>"] = actions.file_vsplit,
      },
      i = {
        ["<C-t>"] = actions.select_tab,
        ["<C-s>"] = actions.file_vsplit,
      },
    },
  },
})
