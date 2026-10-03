-- Called by lazygit's edit commands (below) over $NVIM: hide the lazygit
-- window instead of quitting lazygit, so its state survives opening a file.
function _G.LazygitHide()
  for _, term in ipairs(Snacks.terminal.list()) do
    local info = term:buf_valid() and vim.b[term.buf].snacks_terminal
    if info and term:win_valid() and vim.inspect(info.cmd):find("lazygit") then
      term:hide()
    end
  end
  return ""
end

local remote = 'nvim --server "$NVIM" '
local hide = remote .. "--remote-expr 'v:lua.LazygitHide()' >/dev/null && "

return {
  {
    "folke/snacks.nvim",
    opts = {
      terminal = {
        win = {
          keys = {
            -- LazyVim makes <C-/> hide *every* Snacks terminal window, which also
            -- hits lazygit and the Claude panel (breaking it when zoomed). Drop
            -- that, so <C-/> falls through to the global map and only ever
            -- toggles the plain shell terminal.
            hide_slash = false,
            hide_underscore = false,
          },
        },
      },
      lazygit = {
        -- The nvim-remote preset sends "q" to Neovim before opening a file,
        -- which lands in lazygit and quits it. Hide the window instead.
        config = {
          os = {
            edit = hide .. remote .. "--remote {{filename}}",
            editAtLine = hide .. remote .. "--remote {{filename}} && "
              .. remote .. "--remote-expr 'execute(\"{{line}}\")' >/dev/null",
          },
        },
        win = {
          keys = {
            -- Hide (not quit) so lazygit keeps its state for the next <A-g>.
            hide_lazygit = { "<A-g>", "hide", desc = "Hide Lazygit", mode = { "n", "t" } },
          },
        },
      },
    },
    keys = {
      {
        "<A-g>",
        function()
          Snacks.lazygit({ cwd = LazyVim.root.git() })
        end,
        mode = { "n", "i", "t" },
        desc = "Toggle Lazygit",
      },
    },
  },
}
