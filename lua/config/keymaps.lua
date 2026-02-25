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
