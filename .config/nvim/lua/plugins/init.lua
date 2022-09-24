-- plugin specific configs
require("plugins.configs.nvim-cmp-config")
require("plugins.configs.nvim-neo-tree-config")
require("plugins.configs.mason-config")
require("plugins.configs.nvim-treesitter-config")
require("plugins.configs.nvim-treesitter-context-config")
require("plugins.configs.nvim-lsp-config-config")
require("plugins.configs.gitsigns-config")
require("plugins.configs.bufferline-config")
require("plugins.configs.lualine-config")
require("plugins.configs.colorizer-config")
require("plugins.configs.format-config")
require("plugins.configs.telescope-config")
require("plugins.configs.rust-tools-config")
require("plugins.configs.indent-blankline-config")
require("plugins.configs.diffview-config")
require("plugins.configs.scrollbar-config")

-- packer config
return require("packer").startup(function()
  use("wbthomason/packer.nvim")
  use("bluz71/vim-nightfly-guicolors")
  use("folke/tokyonight.nvim")
  use({ "catppuccin/nvim", as = "catppuccin" })
  use("p00f/nvim-ts-rainbow")
  use("norcalli/nvim-colorizer.lua")
  use("psliwka/vim-smoothie")
  use({
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    requires = {
      "nvim-lua/plenary.nvim",
      "kyazdani42/nvim-web-devicons", -- for file icons
      "MunifTanjim/nui.nvim",
    },
  })

  -- IDE-esque
  use({
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  })
  use("mfussenegger/nvim-dap")
  use("mfussenegger/nvim-lint")
  use({ "mhartington/formatter.nvim" })

  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  })
  use("nvim-treesitter/nvim-treesitter-context")
  use({
    "nmac427/guess-indent.nvim",
    config = function()
      require("guess-indent").setup({})
    end,
  })
  use({
    "terrortylor/nvim-comment",
    config = function()
      require("nvim_comment").setup()
    end,
  })
  use("lewis6991/gitsigns.nvim")
  use({
    "nvim-telescope/telescope.nvim",
    requires = { { "nvim-lua/plenary.nvim" } },
  })
  use({
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
  })
  use({ "akinsho/bufferline.nvim", tag = "v2.*", requires = "kyazdani42/nvim-web-devicons" })
  use({
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  })
  use({
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  })

  use({
    "sindrets/diffview.nvim",
    requires = "nvim-lua/plenary.nvim",
  })
  use({
    "akinsho/git-conflict.nvim",
    tag = "*",
    config = function()
      require("git-conflict").setup()
    end,
  })
  use("kdheepak/lazygit.nvim")

  use("lukas-reineke/indent-blankline.nvim")
  use("petertriho/nvim-scrollbar")

  -- language specific
  use("simrat39/rust-tools.nvim")
  use("phelipetls/vim-hugo")

  -- experimental vscode ssh-esque
  use({
    "chipsenkbeil/distant.nvim",
    config = function()
      require("distant").setup({
        ["*"] = require("distant.settings").chip_default(),
      })
    end,
  })

  -- completion
  use("hrsh7th/cmp-nvim-lsp")
  use("hrsh7th/cmp-buffer")
  use("hrsh7th/cmp-path")
  use("hrsh7th/cmp-cmdline")
  use("hrsh7th/nvim-cmp")
  use("hrsh7th/cmp-vsnip")
  use("hrsh7th/vim-vsnip")
end)
