-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set({ "n", "i", "t" }, "<A-m>", function()
  Snacks.zen.zoom()
end, { desc = "Toggle Zoom" })

vim.keymap.set({ "n", "i", "t" }, "<C-S-Up>", "<C-\\><C-n><C-w>k", { desc = "Move to window above" })
vim.keymap.set({ "n", "i", "t" }, "<C-S-Down>", "<C-\\><C-n><C-w>j", { desc = "Move to window below" })
vim.keymap.set({ "n", "i", "t" }, "<C-S-Left>", "<C-\\><C-n><C-w>h", { desc = "Move to left window" })
vim.keymap.set({ "n", "i", "t" }, "<C-S-Right>", "<C-\\><C-n><C-w>l", { desc = "Move to right window" })

-- Delete without overwriting clipboard
vim.keymap.set({ "n", "v" }, "d", '"_d', { desc = "Delete without yanking" })
vim.keymap.set({ "n", "v" }, "D", '"_D', { desc = "Delete to end without yanking" })
vim.keymap.set({ "n", "v" }, "<Del>", '"_x', { desc = "Delete char without yanking" })
vim.keymap.set("n", "d<Up>", function()
  local line = vim.fn.line(".")
  if line > 1 then
    vim.api.nvim_buf_set_lines(0, line - 2, line - 1, false, {})
  end
end, { desc = "Delete line above without yanking" })
vim.keymap.set("n", "d<Down>", function()
  local line = vim.fn.line(".")
  if line < vim.fn.line("$") then
    vim.api.nvim_buf_set_lines(0, line, line + 1, false, {})
  end
end, { desc = "Delete line below without yanking" })

-- Toggle the gitsigns blame column for the current buffer, keeping focus
-- (and insert mode) in the current window
vim.keymap.set({ "n", "i" }, "<A-l>", function()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "gitsigns-blame" then
      vim.api.nvim_win_close(win, false)
      return
    end
  end
  local cur = vim.api.nvim_get_current_win()
  require("gitsigns").blame(nil, function()
    vim.schedule(function()
      if vim.api.nvim_win_is_valid(cur) then
        vim.api.nvim_set_current_win(cur)
      end
    end)
  end)
end, { desc = "Toggle Git Blame Column" })

-- Plain shell terminals (Snacks terminals without a cmd, i.e. not lazygit/Claude),
-- sorted by their terminal number
local function shell_terminals()
  local ret = {}
  for _, term in ipairs(Snacks.terminal.list()) do
    local info = vim.b[term.buf].snacks_terminal
    if info and info.cmd == nil then
      table.insert(ret, term)
    end
  end
  table.sort(ret, function(a, b)
    return vim.b[a.buf].snacks_terminal.id < vim.b[b.buf].snacks_terminal.id
  end)
  return ret
end

-- <C-/>: show/hide all shell terminals together (replaces LazyVim's, which only
-- handles terminal #1). A count (e.g. 2<C-/>) keeps the original behavior.
local function toggle_terminals()
  local terms = shell_terminals()
  if vim.v.count > 0 or #terms == 0 then
    return Snacks.terminal.focus(nil, { cwd = LazyVim.root() })
  end
  local visible = vim.tbl_filter(function(t)
    return t:win_valid()
  end, terms)
  if vim.tbl_contains(terms, function(t)
    return t.buf == vim.api.nvim_get_current_buf()
  end, { predicate = true }) then
    -- Closing split terminals one by one widens the remaining ones, and Neovim
    -- resizes them right away; each resize makes the shell redraw its prompt
    -- (piling up duplicates). Detach the terminal buffers first so no window
    -- shows them, which keeps their size untouched, then close the windows.
    local scratch = vim.api.nvim_create_buf(false, true)
    vim.bo[scratch].bufhidden = "wipe"
    for _, t in ipairs(visible) do
      vim.api.nvim_win_call(t.win, function()
        vim.cmd("noautocmd buffer " .. scratch)
      end)
    end
    for _, t in ipairs(visible) do
      t:hide()
    end
  elseif #visible > 0 then
    visible[1]:focus()
  else
    for _, t in ipairs(terms) do
      t:show()
    end
    terms[1]:focus()
  end
end
vim.keymap.set({ "n", "t" }, "<C-/>", toggle_terminals, { desc = "Toggle Terminals" })
vim.keymap.set({ "n", "t" }, "<C-_>", toggle_terminals, { desc = "which_key_ignore" })

-- <A-n> in a shell terminal: open another shell terminal next to it
vim.keymap.set("t", "<A-n>", function()
  local info = vim.b.snacks_terminal
  if not (info and info.cmd == nil) then
    -- not a shell terminal (e.g. lazygit/Claude): pass the key through
    return vim.api.nvim_feedkeys(vim.keycode("<A-n>"), "n", false)
  end
  local max = 0
  for _, t in ipairs(shell_terminals()) do
    max = math.max(max, vim.b[t.buf].snacks_terminal.id)
  end
  Snacks.terminal.focus(nil, { cwd = info.cwd, count = max + 1 })
end, { desc = "New Terminal Split" })
