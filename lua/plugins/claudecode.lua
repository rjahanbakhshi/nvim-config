return {
  { import = "lazyvim.plugins.extras.ai.claudecode" },
  {
    "coder/claudecode.nvim",
    opts = {
      -- When Claude sees TMUX it wraps its OSC 52 clipboard writes (used to
      -- copy its own mouse selection) in tmux's DCS passthrough. Neovim's
      -- terminal does not understand the wrapped form and prints the base64
      -- payload into the panel. Claude decides this from TMUX alone, so unset
      -- only that and leave TERM_PROGRAM as is.
      terminal_cmd = "env -u TMUX claude",
      env = {
        -- Konsole and tmux send Ctrl+Backspace as 0x08 (Ctrl+H), which Claude
        -- only treats as Ctrl+Backspace on Windows unless told so here.
        CLAUDE_CODE_BS_AS_CTRL_BACKSPACE = "1",
      },
      terminal = {
        snacks_win_opts = {
          keys = {
            -- LazyVim's Snacks terminal key <C-h> (go to left window) would
            -- swallow that byte; let it reach Claude in this terminal.
            nav_h = false,
          },
        },
      },
    },
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
