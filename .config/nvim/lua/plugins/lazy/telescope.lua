local actions = require("telescope.actions")
return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  -- or                              , branch = '0.1.x',
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
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
  },
}
