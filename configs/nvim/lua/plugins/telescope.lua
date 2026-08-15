vim.pack.add({
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
})

local actions = require("telescope.actions")
require("telescope").setup({
	defaults = {
		mappings = {
			i = {
				["<C-k>"] = actions.move_selection_previous,
				["<C-j>"] = actions.move_selection_next,
			},
			n = {
				["<C-k>"] = actions.preview_scrolling_up,
				["<C-j>"] = actions.preview_scrolling_down,
			},
		},
	},
})

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<space>fs", builtin.lsp_document_symbols, { desc = "[F]ile [S]ymbols" })
vim.keymap.set("n", "<space>sn", builtin.lsp_document_symbols, { desc = "[S]earch local symbol [N]ames" })
vim.keymap.set("n", "<space>sN", builtin.lsp_workspace_symbols, { desc = "[S]earch workspace symbol [N]ames" })
vim.keymap.set("n", "<space>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<space>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
vim.keymap.set("n", "<space>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<space>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
vim.keymap.set("n", "<space>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<space>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<space>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<space>sr", builtin.resume, { desc = "[S]earch [R]esume" })
vim.keymap.set("n", "<space>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set("n", "<space><space>", builtin.buffers, { desc = "[ ] Find existing buffers" })
