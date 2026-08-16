vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/folke/lazydev.nvim" },
	{ src = "https://github.com/Bilal2453/luvit-meta" },
	{ src = "https://github.com/mason-org/mason.nvim" },
})
local servers = {
	"rust_analyzer",
	"gleam",
	"elp",
	"zls",
	"lua_ls",

	-- python
	"ruff",
	"ty",

	-- nix
	"nil_ls",

	-- inclusivity
	"woke",

	-- web
	"prettier",
	"biome",
	"cssls",
	-- "tailwindcss",

	-- rust
	"rust_analyzer",

	-- markdown
	"markdown_oxide",

	-- toml
	"taplo",
}

vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.api.nvim_set_hl(0, "Pmenu", { bg = "#1f2335", fg = "#c0caf5" })
vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#364a82", bold = true })
vim.opt.pumheight = 10
vim.opt.pumblend = 10

-- Setup I kinda stole from ollie
-- ...using lazydev because we both seem to be a lil lazy!
-- lazydev -----------------------------------------
require("lazydev").setup({
	ft = "lua",
	library = {
		-- See the configuration section for more details
		-- Load luvit types when the `vim.uv` word is found
		{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
	},
})

require("mason").setup({})

-- lsp setup ---------------------------------------
vim.lsp.enable(servers)

-- keybinds / settings

vim.lsp.inlay_hint.enable(true)

-- format on write
vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function(event)
		vim.lsp.buf.format({ bufnr = event.buf })
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
	callback = function(event)
		-- Function to map specific lsp related items
		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
			local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = true })

			-- Highlight references of the word under cursor when cursor rests for a little while
			---@diagnostic disable-next-line: param-type-mismatch
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})

			-- Clear highlights when cursor moves again
			---@diagnostic disable-next-line: param-type-mismatch
			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})

			-- handle LspDetach
			---@diagnostic disable-next-line: param-type-mismatch
			vim.api.nvim_create_autocmd({ "LspDetach" }, {
				group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
				end,
			})
		end
		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
			map("<leader>th", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
			end, "[T]oggle Inlay [H]ints")
		end
	end,
})
