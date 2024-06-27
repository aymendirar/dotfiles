-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins.lazy" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "catppuccin" } },
  -- automatically check for plugin updates
  checker = { enabled = true, notify = false }, -- automatically check for plugin updates
})

require("plugins.configs.nvim-cmp-config")
require("plugins.configs.nvim-lsp-config-config")
require("plugins.configs.gitsigns-config")
require("plugins.configs.indent-blankline-config")
require("plugins.configs.raindbow-delimiters-config")
require("plugins.configs.diffview-config")
require("plugins.configs.gitlinker-config")
require("plugins.configs.format-config")
