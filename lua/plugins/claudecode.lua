return {
  { import = "lazyvim.plugins.extras.ai.claudecode" },
  {
    "greggh/claudecode.nvim",
    keys = {
      { "<A-a>", "<cmd>ClaudeCode --continue<cr>", mode = { "n", "i", "t" }, desc = "Continue Claude" },
    },
  },
}