-- plugin specific configs
require("plugins.configs.nvim-cmp-config")
require("plugins.configs.nvim-neo-tree-config")
require("plugins.configs.mason-config")
require("plugins.configs.nvim-treesitter-config")
require("plugins.configs.nvim-treesitter-context-config")
require("plugins.configs.nvim-lsp-config-config")
require("plugins.configs.gitsigns-config")
require("plugins.configs.gitlinker-config")
require("plugins.configs.bufferline-config")
-- require("plugins.configs.lualine-config")
require("plugins.configs.feline-config")
require("plugins.configs.colorizer-config")
require("plugins.configs.format-config")
require("plugins.configs.telescope-config")
require("plugins.configs.rust-tools-config")
require("plugins.configs.indent-blankline-config")
require("plugins.configs.diffview-config")
require("plugins.configs.scrollbar-config")
require("plugins.configs.peek-config")
require("plugins.configs.toggle-term-config")
require("plugins.configs.easypick-config")

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- packer config
return require("packer").startup(function()
  use("wbthomason/packer.nvim")
  use("bluz71/vim-nightfly-guicolors")
  use("folke/tokyonight.nvim")
  use({ "catppuccin/nvim", as = "catppuccin" })
  use({ "pappasam/papercolor-theme-slim" })
  use({ "daschw/leaf.nvim" })
  use({ "ellisonleao/gruvbox.nvim" })
  use({ "projekt0n/github-nvim-theme" })
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
  use("ray-x/lsp_signature.nvim")
  use("mfussenegger/nvim-dap")
  use({ "rcarriga/nvim-dap-ui" })
  use("mfussenegger/nvim-lint")
  use({ "mhartington/formatter.nvim" })
  use({ "gpanders/editorconfig.nvim" })

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
  use("ruifm/gitlinker.nvim")
  use("xiyaowong/telescope-emoji.nvim")
  use({
    "nvim-telescope/telescope.nvim",
    requires = { { "nvim-lua/plenary.nvim" } },
  })
  use({
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
  })
  use("feline-nvim/feline.nvim")
  use({
    "utilyre/barbecue.nvim",
    tag = "*",
    requires = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    after = "nvim-web-devicons", -- keep this if you're using NvChad
    config = function()
      require("barbecue").setup()
    end,
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
  use("tpope/vim-surround")
  use({
    "folke/trouble.nvim",
    requires = "nvim-tree/nvim-web-devicons",
    config = function()
      require("trouble").setup()
    end,
  })
  use({ "akinsho/toggleterm.nvim", tag = "*" })

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
  use {'axkirillov/easypick.nvim', requires = 'nvim-telescope/telescope.nvim'}

  use("lukas-reineke/indent-blankline.nvim")
  use("petertriho/nvim-scrollbar")
  use("stevearc/dressing.nvim")
  use("nvim-pack/nvim-spectre")
  use("tpope/vim-fugitive")

  -- language specific
  use("simrat39/rust-tools.nvim")
  use("phelipetls/vim-hugo")
  use({
    "iamcco/markdown-preview.nvim",
    run = function()
      vim.fn["mkdp#util#install"]()
    end,
  })
  use({ "toppair/peek.nvim", run = "deno task --quiet build:fast" })


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

  if packer_bootstrap then
    require("packer").sync()
  end
end)
