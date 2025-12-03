return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    event = "VeryLazy",
    config = function()
      local actions = require("telescope.actions")
      local additional_rg_args = { "--hidden", "--glob", "!.git/*", "--glob", "!node_modules/*" }
      require("telescope").setup({
        defaults = {
          hidden = true,
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            "--glob",
            "!.git/*",
            "--glob",
            "!node_modules/*",
          },
          -- <C-x> for horizontal split
          -- <C-v> for vertical split
          mappings = {
            i = {
              ["<A-Down>"] = actions.cycle_history_next,
              ["<A-Up>"] = actions.cycle_history_prev,
            },
          },
          pickers = {
            -- idk how to make telescope respect this config
            -- i just threw it into the mappings/init.lua arguments and that seems to work for now
            find_files = {
              hidden = true,
              find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*", "--glob", "!node_modules/*" },
            },
          },
          live_grep = { additional_args = additional_rg_args },
          grep_string = { additional_args = additional_rg_args },
        },
      })
    end,
  },
}
