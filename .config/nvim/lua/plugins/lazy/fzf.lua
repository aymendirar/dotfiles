return {
  "ibhagwan/fzf-lua",
  -- optional for icon support
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- calling `setup` is optional for customization
    require("fzf-lua").setup({
      files = {
        -- <C-p>, <C-n> to go through history
        fzf_opts = {
          ["--history"] = vim.fn.shellescape(vim.fn.stdpath("data") .. "/fzf_files_hist"),
        },
      },
    })
  end,
}
