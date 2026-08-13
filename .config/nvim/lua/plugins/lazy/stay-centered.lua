return {
  "arnamak/stay-centered.nvim",
  -- disabled for ssh: forcing the view to recenter turns most vertical cursor
  -- moves into a full screen repaint, which is free locally but costs a round
  -- trip over a remote terminal. disable_on_mouse also puts a vim.on_key
  -- callback on every keystroke. scrolloff=12 already keeps the cursor off the
  -- edges; flip this back to true if the recentring is worth the redraws
  enabled = false,
  lazy = false,
  config = function()
    require("stay-centered").setup({
      -- The filetype is determined by the vim filetype, not the file extension. In order to get the filetype, open a file and run the command:
      -- :lua print(vim.bo.filetype)
      skip_filetypes = {},
      -- Set to false to disable by default
      enabled = true,
      -- allows scrolling to move the cursor without centering, default recommended
      allow_scroll_move = true,
      -- temporarily disables plugin on left-mouse down, allows natural mouse selection
      -- try disabling if plugin causes lag, function uses vim.on_key
      disable_on_mouse = true,
    })
  end,
}
