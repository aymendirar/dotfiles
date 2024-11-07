local actions = require("telescope.actions")
local additional_rg_args = { "--hidden", "--glob", "!.git/*", "--glob", "!node_modules/*" }

return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    event = "VeryLazy",
    config = function()
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
        extensions = {
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "ignore_case", -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          },
        },
      })
      require("telescope").load_extension("fzf")
    end,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
  },
}
