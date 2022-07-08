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
  },
})
