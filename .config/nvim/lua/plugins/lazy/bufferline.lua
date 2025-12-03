return {
  "akinsho/bufferline.nvim",
  -- version = "v3.*",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin" },
  config = function()
    local highlights = {}
    local ok, catppuccin = pcall(require, "catppuccin.groups.integrations.bufferline")
    if ok then
      local get_highlights = catppuccin.get()
      if type(get_highlights) == "function" then
        highlights = get_highlights()
      end
    end

    require("bufferline").setup({
      options = {
        mode = "buffers",
      },
      highlights = highlights,
    })
  end,
}
