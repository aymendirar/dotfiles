return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "macchiato",
      transparent_background = true, -- disables setting the background color.
      term_colors = true,
      styles = {
        comments = { "italic" },
        conditionals = {},
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },
      dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
      },
      color_overrides = {
        latte = {
          base = "#EDEFF3",
        },
      },
      custom_highlights = function(_)
        return {
          Type = { style = { "bold", "italic" } },
          Function = { style = { "bold", "italic" } },
          ["@type.builtin"] = { style = { "bold", "italic" } },
          ["@parameter"] = { style = { "bold", "italic" } },
        }
      end,
      integrations = {
        notify = true,
        lsp_saga = true,
        treesitter = true,
        treesitter_context = true,
        cmp = true,
        gitgutter = false,
        gitsigns = true,
        ts_rainbow = true,
        neotree = {
          enabled = true,
          show_root = true,
          transparent_panel = false,
        },
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
        },
        indent_blankline = {
          enabled = true,
          colored_indent_levels = false,
        },
        telescope = {
          enabled = true,
        },
        rainbow_delimiters = true,
        mason = true,
      },
    })
    vim.cmd.colorscheme("catppuccin")
    vim.api.nvim_set_hl(0, "LineNr", { fg = "#737994" })
    vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { fg = "#737994", italic = true })
  end,
}
