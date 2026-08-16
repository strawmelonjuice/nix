local map = vim.keymap.set
local wk = require("which-key")
local telescopeapi = require("telescope.builtin")
local function trim(s)
	return s:match("(.-)%s*%-*$")
end
-- Default seperator: ~~~~
local sep = "~"

-- Misc. ==============================================================================================================================================

-- Visual VCS managers group
wk.add({
	{
		"<leader>v",
		group = "[V]isual VCS",
		mode = { "n" },
	},
})
-- Setting it twice so we're certain it works but also have the correct WK label.
require("lazyjj").setup({ mapping = "<leader>vj" })
map("n", "<leader>vj", "LazyJJ", { desc = "[V]isual [J]J (LazyJJ)" })
map("n", "<leader>vg", "LazyGit", { desc = "[V]isual [G]it (LazyGit)" })

-- Control-S save
map("i", "<C-s>", "<esc><cmd>w<cr>", { desc = "Save and go to normal mode" })
map("v", "<C-s>", "<esc><cmd>w<cr>", { desc = "Save and go to normal mode" })
map("n", "<C-s>", "<cmd>w<cr>", { desc = "Save and stay in normal mode" })

-- Splitting
map("n", "<space>\\", "<cmd>vsplit<CR>", { desc = "Vertical split" })
map("n", "<space>-", "<cmd>split<CR>", { desc = "Horizontal split" })

-- Pickers/Telescope and LSP actions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
wk.add({
	{ "<leader>s", group = "[S]earch and pick", mode = { "n", "v" } },
	{ "<leader>w", group = "[W]orkspace", mode = { "n", "v" } },
	{ "<leader>f", group = "[F]ile", mode = { "n", "v" } },
	{ "<leader>c", group = "Under [C]ursor", mode = { "n", "v" } },
})
map("n", "<leader>fs", telescopeapi.lsp_document_symbols, { desc = "[F]ile [S]ymbols" })
map("n", "<leader>ws", telescopeapi.lsp_workspace_symbols, { desc = "[W]orkspace [S]ymbols" })
map("n", "<leader>sn", telescopeapi.lsp_document_symbols, { desc = "[S]earch local symbol [N]ames" })
map("n", "<leader>sN", telescopeapi.lsp_workspace_symbols, { desc = "[S]earch workspace symbol [N]ames" })
map("n", "<leader>sh", telescopeapi.help_tags, { desc = "[S]earch [H]elp" })
map("n", "<leader>sk", telescopeapi.keymaps, { desc = "[S]earch [K]eymaps" })
map("n", "<leader>sf", telescopeapi.find_files, { desc = "[S]earch [F]iles" })
map("n", "<leader>ss", telescopeapi.builtin, { desc = "[S]earch [S]elect Telescope" })
map("n", "<leader>sw", telescopeapi.grep_string, { desc = "[S]earch current [W]ord" })
map("n", "<leader>s/", telescopeapi.live_grep, { desc = '[S]earch by grep ("/" for searching)' })
map("n", "<leader>sg", telescopeapi.live_grep, { desc = '[S]earch by [G]rep (aliased: "/")' })
map("n", "<leader>sd", telescopeapi.diagnostics, { desc = "[S]earch [D]iagnostics" })
map("n", "<leader>fd", telescopeapi.diagnostics, { desc = "[F]ile [D]iagnostics" })
map("n", "<leader>sr", telescopeapi.resume, { desc = "[S]earch [R]esume" })
map("n", "<leader>s.", telescopeapi.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
map("n", "<leader>so", telescopeapi.oldfiles, { desc = '[S]earch [O]ldfiles (aliased: ".")' })
map("n", "<leader><space>", telescopeapi.buffers, { desc = "[ ] Find existing buffers" })
map({ "n", "v" }, "gd", vim.lsp.buf.definition, { desc = "[G]oto [D]efinition" })
map("n", "gb", "''", { desc = "[G]o [B]ack" })
map({ "n", "v" }, "gr", telescopeapi.lsp_references, { desc = "[G]oto [R]eferences" })
map({ "n", "v" }, "gI", telescopeapi.lsp_implementations, { desc = "[G]oto [I]mplementation" })
map({ "n", "v" }, "<leader>cD", telescopeapi.lsp_type_definitions, { desc = "Type [D]efinition" })
map({ "n", "v" }, "<leader>ws", telescopeapi.lsp_dynamic_workspace_symbols, { desc = "[W]orkspace [S]ymbols" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "[G]oto [D]eclartion" })
map("n", "<C-k>", vim.lsp.buf.hover, {})
map("i", "<C-k>", vim.lsp.buf.hover, {})
map("v", "<C-k>", vim.lsp.buf.hover, {})
map({ "n", "v" }, "<leader>ci", vim.lsp.buf.hover, { desc = "Show [I]nfo" })
map("n", "<leader>ff", vim.lsp.buf.format, { desc = "[F]ormat [F]ile" })
map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Trigger LSP [A]ction" })
map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "[R]ename symbol" })
map("n", "<space>ce", vim.diagnostic.open_float, { desc = "Open [E]rror [W]indow" })

local show_errors = false
-- toggle showing virtual_lines
vim.keymap.set("n", "we", function()
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
end, { desc = "toggle [E]rror lines" })

-- Setting the keymap is done several times, so that the description stays accurate.
local create_sep_kb = function()
	map("n", "<space>cs", function()
		-- get current line(string) and row(int) in the buffer
		local line = trim(vim.api.nvim_get_current_line())
		local row, _ = unpack(vim.api.nvim_win_get_cursor(0))

		-- make "~~~~~~~~~~~~" seperator line at consistent length
		local seperator = string.rep(sep, 150 - string.len(line))

		-- write line with seperator to current buffer at current cursor position
		vim.api.nvim_buf_set_lines(0, row - 1, row, true, { line .. " " .. seperator })
	end, { desc = "Enter [S]eperator here (" .. sep .. ")" })
end

-- Adding a group of binds for setting it
wk.add({
	{ "<space>cS", group = "[S]et [S]eperator ->", mode = { "n", "v" } },
})
map("n", "<space>cS-", function()
	sep = "-"
	create_sep_kb()
end, { desc = "To '---'" })
map("n", "<space>cS=", function()
	sep = "="
	create_sep_kb()
end, { desc = "To '==='" })
map("n", "<space>cS`", function()
	sep = "~"
	create_sep_kb()
end, { desc = "To '~~~' (default)" })

-- ...and using it!
create_sep_kb()

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
