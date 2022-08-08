local actions = require("telescope.actions")
require("telescope").setup({
  defaults = {
    mappings = {
      n = {
        ["<C-s>"] = actions.file_vsplit,
      },
      i = {
        ["<C-s>"] = actions.file_vsplit,
      },
    },
  },
})
