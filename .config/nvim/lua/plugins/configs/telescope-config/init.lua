local actions = require("telescope.actions")
require("telescope").setup({
  defaults = {
    mappings = {
      n = {
        ["<CR>"] = actions.select_tab,
        ["<C-s>"] = actions.file_vsplit,
      },
      i = {
        ["<CR>"] = actions.select_tab,
        ["<C-s>"] = actions.file_vsplit,
      },
    },
  },
})
