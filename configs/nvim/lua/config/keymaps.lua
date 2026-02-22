local map = vim.keymap.set
local wk = require("which-key")

-- Misc.        --------------------------------------------------------------------------------------------------------------------------------------------------

-- Visual VCS managers group
wk.add({
	{ "<Space>v", group = "Visual VCS", mode = { "n" } },
})
-- Control-S save
map("i", "<C-s>", "<esc><cmd>w<cr>", { desc = "Save and go to normal mode" })
map("v", "<C-s>", "<esc><cmd>w<cr>", { desc = "Save and go to normal mode" })
map("n", "<C-s>", "<cmd>w<cr>", { desc = "Save and stay in normal mode" })

-- Splitting
map("n", "<Space>\\", "<cmd>vsplit<CR>", { desc = "Vertical split" })
map("n", "<Space>-", "<cmd>split<CR>", { desc = "Horizontal split" })

-- Pickers      --------------------------------------------------------------------------------------------------------------------------------------------------
---@diagnostic disable-next-line: assign-type-mismatch
map("n", "<Space>f", function()
	Snacks.picker.files()
end, { desc = "Open file picker" })

map("n", "<Space>/", function()
	Snacks.picker.grep()
end, { desc = "Project grep" })

map("n", "<Space>d", function()
	Snacks.picker.diagnostics_buffer()
end, { desc = "Buffer diagnostics" })

map("n", "<Space>D", function()
	Snacks.picker.diagnostics()
end, { desc = "Project diagnostics" })

map("n", "<Space>b", function()
	Snacks.picker.buffers()
end, { desc = "Open buffer picker" })

map("n", "<Space>s", function()
	Snacks.picker.lsp_symbols()
end, { desc = "Open symbol picker" })

map("n", "<Space>S", function()
	Snacks.picker.lsp_workspace_symbols()
end, { desc = "Open project symbol picker" })

map("n", "<Space>?", function()
	Snacks.picker.commands()
end, { desc = "Open command picker" })

map("n", "<Space>r", function()
	Snacks.picker.resume()
end, { desc = "Resume last search" })

map("n", "<Space>o", "<cmd>FzfLua oldfiles<CR>", { desc = "Oldfiles" })

map("n", "<Space>e", function()
	Snacks.explorer({ layout = { layout = { position = "right" } } })
end, { desc = "Explorer" })

map("n", "<Space><Space>", function()
	Snacks.picker.resume()
end, { desc = "Resume last search" })

-- LSP          --------------------------------------------------------------------------------------------------------------------------------------------------
-- LSP group
wk.add({
	{ "<Space>c", group = "LSP ->", mode = { "n", "v" } },
})
-- Hover info
map("n", "<C-k>", vim.lsp.buf.hover, {})
map("i", "<C-k>", vim.lsp.buf.hover, {})
map("v", "<C-k>", vim.lsp.buf.hover, {})
map("n", "<space>ci", vim.lsp.buf.hover, { desc = "LSP -> Hover info" })
map("v", "<space>ci", vim.lsp.buf.hover, { desc = "LSP -> Hover info" })

-- Code action
map("n", "<space>ca", vim.lsp.buf.code_action, { desc = "LSP -> Code action" })
map("v", "<space>ca", vim.lsp.buf.code_action, { desc = "LSP -> Code action" })
-- Rename
map("n", "<Space>cr", vim.lsp.buf.rename, { desc = "LSP -> Rename symbol" })

-- Movement     --------------------------------------------------------------------------------------------------------------------------------------------------
map("i", "<down>", "<esc>gj", { desc = "Move down and exit insert" })
map("i", "<up>", "<esc>gk", { desc = "Move up and exit insert" })

-- Selections   --------------------------------------------------------------------------------------------------------------------------------------------------
map("n", "x", "V", { desc = "Select line" })
map("v", "x", "j", { desc = "Extend selection down" })
map("v", "X", "k", { desc = "Extend selection up" })
map("v", "d", "d", { desc = "Delete selection" })
map("v", "c", "c", { desc = "Change selection" })
map("v", "y", "y", { desc = "Yank selection" })
map("n", "d", "x", { desc = "Delete character" })
map("n", "w", "viw", { desc = "Select inner word" })
map("n", "e", "ve", { desc = "Select to end of word" })
map("n", "w", "viw", { desc = "Select word" })
map("n", "e", "ve", { desc = "Select to end of word" })
map("n", "b", "vb", { desc = "Select to start of word" })
map("n", "mi", "vi", { desc = "Select Inside..." })
map("n", "ma", "va", { desc = "Select Around..." })
