return {
  {
    "gbprod/yanky.nvim",
    opts = {
      system_clipboard = {
        clipboard_register = "clipboard",
      },
    },
    config = function(_, opts)
      require("yanky").setup(opts)
      -- Paste over selection without overwriting clipboard
      vim.keymap.set("v", "p", '"_dP', { desc = "Paste without yanking selection" })
    end,
  },
}
