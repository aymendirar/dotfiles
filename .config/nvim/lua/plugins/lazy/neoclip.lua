return {
  "AckslD/nvim-neoclip.lua",
  dependencies = {
    {'kkharji/sqlite.lua', module = 'sqlite'},
    -- you'll need at least one of these
    -- {'nvim-telescope/telescope.nvim'},
    -- {'ibhagwan/fzf-lua'},
  },
  event = "VeryLazy",
  config = function()
    require('neoclip').setup({
      enable_persistent_history = true,
    })
  end,
}
