-- Options are automatically loaded before lazy.nvim startup
-- Add any additional options here

-- // Set mapleader to space
vim.cmd.let('mapleader = "<space>"')

vim.opt.relativenumber = true

vim.opt.mouse = "a"

vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"

local show_errors = false
-- toggle showing virtual_lines
vim.keymap.set("n", "Te", function()
	if show_errors then
		-- // Initially set as lsp-config setting inside ../plugins/lsp.lua
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
