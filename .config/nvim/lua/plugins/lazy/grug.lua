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
      folding = {
        -- whether to enable folding
        enabled = true,

        -- sets foldlevel, folds with higher level will be closed.
        -- result matche lines for each file have fold level 1
        -- set it to 0 if you would like to have the results initially collapsed
        -- See :h foldlevel
        foldlevel = 0,

        -- visual indicator of folds, see :h foldcolumn
        -- set to '0' to disable
        foldcolumn = "1",
      },
    })
  end,
}
