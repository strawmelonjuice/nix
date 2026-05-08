vim.opt.relativenumber = true

vim.opt.mouse = "a"

vim.opt.clipboard = "unnamedplus"

vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"

vim.diagnostic.config({
	virtual_text = {
		format = function(diag)
			return string.match(diag.message, "(.-)\n") or diag.message
		end,
	},
	virtual_lines = { current_line = true },
})

