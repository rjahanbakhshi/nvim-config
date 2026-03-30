return {
  { import = "lazyvim.plugins.extras.ai.claudecode" },
  {
    "coder/claudecode.nvim",
    keys = {
      { "<A-a>", "<cmd>ClaudeCode --continue<cr>", mode = { "n", "i", "t" }, desc = "Continue Claude" },
    },
  },
}
