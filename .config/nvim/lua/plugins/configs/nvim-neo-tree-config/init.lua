require("neo-tree").setup({
  close_if_last_window = true,
  window = {
    position = "right",
  },
  filesystem = {
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
    },
  },
})
