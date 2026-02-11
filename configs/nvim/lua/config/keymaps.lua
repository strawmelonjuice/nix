-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
map("i", "<C-J>", 'copilot#Accept("\\<CR>")', {
    expr = true,
    replace_keycodes = false,
})

vim.g.copilot_no_tab_map = true
map("n", "K", "<cmd>Lspsaga hover_doc<CR>")
-- Exit insert mode when using the bad habit of pressing the arrow keys, but still move
-- I am actively making things hard for-- well, me probably
vim.api.nvim_set_keymap("i", "<Up>", "<ESC>gk", {})
-- vim.api.nvim_set_keymap("i", "<Left>", "<ESC>h", {})
-- vim.api.nvim_set_keymap("i", "<Right>", "<ESC>l", {})

-- I can't get rid of my ,-leaderkey. But I do wanna use space in the Helix-like space menu way... so yes!
---@diagnostic disable-next-line: assign-type-mismatch
map("n", "<Space>f", function()
    Snacks.picker.files({ cwd = true })
end, { desc = "Open file picker (cwd)" })
map("n", "<Space>g", function()
    Snacks.picker.grep()
end, { desc = "Grep" })
map("n", "<Space>b", function()
    Snacks.picker.buffers()
end, { desc = "Open buffer picker" })
map("n", "<Space>s", function()
    Snacks.picker.lsp_symbols()
end, { desc = "Open symbol picker" })
map("n", "<Space>S", function()
    Snacks.picker.lsp_symbols({ cwd = true })
end, { desc = "Open symbol picker (cwd)" })
map("n", "<Space>?", function()
    Snacks.picker.commands()
end, { desc = "Open command picker" })
map("n", "<Space>r", function()
    Snacks.picker.resume()
end, { desc = "Resume last search" })
map("n", "<Space><Space>", function()
    Snacks.picker.resume()
end, { desc = "Resume last search" })
map("n", "<Space>c", "<cmd>normal gcc<CR>", { desc = "Comment line" })
map("n", "<Space>\\", "<cmd>vsplit<CR>", { desc = "Vertical split" })
map("n", "<Space>-", "<cmd>split<CR>", { desc = "Horizontal split" })

map("n", "<C-s>", "<cmd>w<cr>", { desc = "Save file" })

map("i", "<C-s>", "<esc><cmd>w<cr>", { desc = "Save and go to normal mode" })

map("i", "<down>", "<esc>gj", { desc = "Move down and exit insert" })
map("i", "<up>", "<esc>gk", { desc = "Move up and exit insert" })

map("n", "x", "V", { desc = "Select line" })
map("v", "x", "j", { desc = "Extend selection down" })
map("v", "X", "k", { desc = "Extend selection up" })
map("v", "d", "d", { desc = "Delete selection" })
map("v", "c", "c", { desc = "Change selection" })
map("v", "y", "y", { desc = "Yank selection" })
map("n", "d", 'x', { desc = "Delete character (Helix-style)" })
map("n", "w", "viw", { desc = "Select inner word" })
map("n", "e", "ve", { desc = "Select to end of word" })
map("n", "w", "viw", { desc = "Select word" })
map("n", "e", "ve", { desc = "Select to end of word" })
map("n", "b", "vb", { desc = "Select to start of word" })
map("n", "mi", "vi", { desc = "Select Inside..." })
map("n", "ma", "va", { desc = "Select Around..." })
