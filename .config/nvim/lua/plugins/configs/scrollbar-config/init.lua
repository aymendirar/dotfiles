local colors = {
  -- StatusLine background color.
  color0 = "#2c3043",

  -- Mode colors.
  color1 = "#82aaff",
  color2 = "#21c7a8",
  color3 = "#ae81ff",
  color4 = "#ecc48d",
  color5 = "#ff5874",

  -- Mode text color.
  color6 = "#092236",

  -- StatusLineNC foreground.
  color7 = "#a1aab8",

  -- Normal text color.
  color8 = "#c3ccdc",
}

require("scrollbar").setup({
  handle = {
    color = nil,
  },
  marks = {
    Search = { color = colors.color1 },
    Error = { color = colors.color5 },
    Warn = { color = colors.color4 },
    Info = { color = colors.color2 },
    Hint = { color = colors.color3 },
    Misc = { color = colors.color6 },
  },
})
