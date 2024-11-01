local actions = require("telescope.actions")
local additional_rg_args = { "--hidden", "--glob", "!**/.git/*", "--glob", "!**/node_modules/*" }

return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    config = function()
      require("telescope").load_extension("fzf")
      require("telescope").setup({
        defaults = {
          -- <C-x> for horizontal split
          -- <C-v> for vertical split
          mappings = {
            i = {
              ["<A-Down>"] = actions.cycle_history_next,
              ["<A-Up>"] = actions.cycle_history_prev,
            },
          },
          pickers = {
            find_files = {
              find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
              hidden = true, -- will still show the inside of `.git/` as it's not `.gitignore`d.
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
    end,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
  },
}
