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
    },
    keys = {
      {
        "<A-a>",
        function()
          -- If the Claude panel is maximized via Snacks zen-zoom, the zoom is a
          -- separate float covering the real Claude window. Toggling Claude while
          -- zoomed closes the window under the float (looks like nothing happens)
          -- and leaves the float orphaned, so un-zooming shows a blank panel.
          -- Exit zoom first so focus returns to the real window.
          -- ClaudeCodeFocus opens/focuses the panel when it is not focused
          -- and hides it only when pressed from inside it (like <C-/> for
          -- the shell terminal).
          if Snacks.zen.win and Snacks.zen.win:valid() then
            Snacks.zen.zoom()
            vim.schedule(function()
              vim.cmd("ClaudeCodeFocus --continue")
            end)
          else
            vim.cmd("ClaudeCodeFocus --continue")
          end
        end,
        mode = { "n", "i", "t" },
        desc = "Focus/Hide Claude",
      },
    },
  },
}
