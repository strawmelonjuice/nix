local map = vim.keymap.set
local wk = require("which-key")

-- Misc. ==============================================================================================================================================

-- Visual VCS managers group
wk.add({
	{ "<space>v", group = "Visual VCS", mode = { "n" } },
})
-- Control-S save
map("i", "<C-s>", "<esc><cmd>w<cr>", { desc = "Save and go to normal mode" })
map("v", "<C-s>", "<esc><cmd>w<cr>", { desc = "Save and go to normal mode" })
map("n", "<C-s>", "<cmd>w<cr>", { desc = "Save and stay in normal mode" })

-- Splitting
map("n", "<space>\\", "<cmd>vsplit<CR>", { desc = "Vertical split" })
map("n", "<space>-", "<cmd>split<CR>", { desc = "Horizontal split" })

-- LSP ================================================================================================================================================
-- LSP group
wk.add({
	{ "<space>c", group = "LSP ->", mode = { "n", "v" } },
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
map("n", "<space>cr", vim.lsp.buf.rename, { desc = "LSP -> Rename symbol" })
-- Stolen from Ollie
local function trim(s)
	return s:match("(.-)%s*%-*$")
end

local show_errors = false
-- toggle showing virtual_lines
vim.keymap.set("n", "Te", function()
	if show_errors then
		vim.diagnostic.config({
			virtual_text = {
				format = function(diagnostic)
					return string.match(diagnostic.message, "(.-)\n")
				end,
			},
			virtual_lines = {
				current_line = true,
			},
		})
		show_errors = false
	else
		vim.diagnostic.config({
			virtual_text = {
				format = function(diagnostic)
					return string.match(diagnostic.message, "(.-)\n")
				end,
			},
			virtual_lines = false,
		})
		show_errors = true
	end
end, { desc = "[T]oggle [E]rrors" })

vim.keymap.set("n", "<space>cew", vim.diagnostic.open_float, { desc = "Open [E]rror [W]indow" })
local sep = "~"
-- Adding a group of binds for setting it :3
wk.add({
	{ "<space>cS", group = "[S]et [S]eperator ->", mode = { "n", "v" } },
})
map("n", "<space>cS-", function()
	sep = "-"
end, { desc = "To '---'" })
map("n", "<space>cS=", function()
	sep = "="
end, { desc = "To '==='" })
map("n", "<space>cS`", function()
	sep = "~"
end, { desc = "To '~~~' (default)" })
-- ...and using it!
map("n", "<space>cs", function()
	-- get current line(string) and row(int) in the buffer
	local line = trim(vim.api.nvim_get_current_line())
	local row, _ = unpack(vim.api.nvim_win_get_cursor(0))

	-- make "~~~~~~~~~~~~" seperator line at consistent length
	local seperator = string.rep(sep, 150 - string.len(line))

	-- write line with seperator to current buffer at current cursor position
	vim.api.nvim_buf_set_lines(0, row - 1, row, true, { line .. " " .. seperator })
end, { desc = "Make [S]eperator" })

-- Movement ===========================================================================================================================================
-- Move cursor within file
map("i", "<down>", "<esc>gj", { desc = "Move down and exit insert" })
map("i", "<up>", "<esc>gk", { desc = "Move up and exit insert" })

-- Move current line
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Line Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Line Up" })
-- Move selection
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move Selection Down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move Selection Up" })

-- Selections =========================================================================================================================================
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
