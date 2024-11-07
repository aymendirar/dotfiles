return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  opts = {
    sources = {
      "filesystem",
    },
    source_selector = {
      winbar = true,
      sources = {
        { source = "filesystem" },
      },
    },
    close_if_last_window = true,
    window = {
      position = "right",
      mappings = {
        ["c"] = {
          "copy",
          config = {
            show_path = "relative",
          },
        },
        ["m"] = {
          "move",
          config = {
            show_path = "relative",
          },
        },
        ["o"] = "system_open",
      },
    },
    filesystem = {
      follow_current_file = {
        enabled = true, -- This will find and focus the file in the active buffer every time
        --               -- the current file is changed while the tree is open.
        leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
      },
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = {
          ".DS_Store",
          "thumbs.db",
          "node_modules",
        },
        never_show = { ".git", "node_modules" },
      },
      use_libuv_file_watcher = true, -- refresh automagically?
      commands = {
        -- Override delete to use trash instead of rm
        delete = function(state)
          local path = state.tree:get_node().path
          vim.fn.system({ "trash", vim.fn.fnameescape(path) })
          require("neo-tree.sources.manager").refresh(state.name)
        end,
        -- open with finder!
        system_open = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          -- escape spaces and parens to make them actually open-able
          local escaped_path = string.gsub(path, ".", {
            [" "] = "\\ ",
            ["("] = "\\(",
            [")"] = "\\)",
          })
          -- macOS: open file in default application
          vim.api.nvim_exec2("!open " .. escaped_path .. "", {})
        end,
      },
      hijack_netrw_behavior = "open_default",
    },
  },
}
