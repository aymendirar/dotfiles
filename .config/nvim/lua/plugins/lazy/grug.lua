return {
  "MagicDuck/grug-far.nvim",
  config = function()
    require("grug-far").setup({
      normalModeSearch = true,
      maxSearchMatches = 500,
      -- highlight the results with TreeSitter, if available
      resultsHighlight = false,

      -- highlight the inputs with TreeSitter, if available
      inputsHighlight = false,
      startInInsertMode = false,
    })
  end,
}
