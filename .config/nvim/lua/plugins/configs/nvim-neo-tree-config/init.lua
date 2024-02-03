require("neo-tree").setup({
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
    follow_current_file = true,
    filtered_items = {
      visible = true,
      hide_dotfiles = false,
      hide_gitignored = true,
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
        vim.api.nvim_exec("!open " .. escaped_path, "")
      end,
    },
  },
})
