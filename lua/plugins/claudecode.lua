return {
  { import = "lazyvim.plugins.extras.ai.claudecode" },
  {
    "coder/claudecode.nvim",
    keys = {
      {
        "<A-a>",
        function()
          -- If the Claude panel is maximized via Snacks zen-zoom, the zoom is a
          -- separate float covering the real Claude window. Toggling Claude while
          -- zoomed closes the window under the float (looks like nothing happens)
          -- and leaves the float orphaned, so un-zooming shows a blank panel.
          -- Exit zoom first so focus returns to the real window, then toggle.
          if Snacks.zen.win and Snacks.zen.win:valid() then
            Snacks.zen.zoom()
            vim.schedule(function()
              vim.cmd("ClaudeCode --continue")
            end)
          else
            vim.cmd("ClaudeCode --continue")
          end
        end,
        mode = { "n", "i", "t" },
        desc = "Continue Claude",
      },
    },
  },
}
