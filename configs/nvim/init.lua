vim.g.mapleader = " "
vim.g.maplocalleader = " "
require("config.options")

local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.deps"
if not vim.loop.fs_stat(mini_path) then
	vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/echasnovski/mini.deps", mini_path })
	vim.cmd("packadd mini.deps")
end

local MiniDeps = require("mini.deps")
MiniDeps.setup({ path = { package = path_package } })
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
	add("folke/tokyonight.nvim")
	add("EdenEast/nightfox.nvim")
	add("nvim-tree/nvim-web-devicons")
	add("folke/which-key.nvim")
	add("nvim-lualine/lualine.nvim")

	local hour = tonumber(os.date("%H"))
	local is_dark = (hour < 6 or hour >= 19)
	local theme = is_dark and "tokyonight-night" or "dayfox"

	vim.o.termguicolors = true
	vim.o.background = is_dark and "dark" or "light"
	vim.cmd.colorscheme(theme)
end)

later(function()
	add("neovim/nvim-lspconfig")
	add("stevearc/conform.nvim")
	require("config.lsp")
	require("config.fmt")

	add({
		source = "nvim-treesitter/nvim-treesitter",
		hooks = {
			post_checkout = function()
				vim.cmd("TSUpdate")
			end,
		},
	})

	add("folke/snacks.nvim")
	require("snacks").setup({
		indent = {
			enabled = true,
			char = "╎",
			scope = {
				enabled = true,
				char = "│",
			},
		},
		dashboard = {
			enabled = true,
			sections = {
				{ section = "header", padding = 5 }, -- Alleen je mooie ASCII art
			},
			preset = {
				header = [[
         ===================================================================
         -------------------------   Mar's Nvim!   -------------------------
         ===================================================================

                    Welcome! It's time to start doing stuff! :3
]],
			},
		},
		picker = { enabled = true },
		explorer = { enabled = true },
	})

	local lualine = require("plugins.lualine")
	lualine.setup()
	add({
		source = "Saghen/blink.cmp",
		checkout = "v1",
	})

	require("blink.cmp").setup({
		keymap = { preset = "default" },

		appearance = {
			use_nvim_cmp_as_default = true,
		},

		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},

		completion = {
			menu = { border = "rounded" },
			documentation = { window = { border = "rounded" }, auto_show = true },
		},
	})

	add("nvim-lua/plenary.nvim")
	add("swaits/lazyjj.nvim")
	add("kdheepak/lazygit.nvim")
	require("plugins.gvc").setup()
	add("windwp/nvim-autopairs")
	require("nvim-autopairs").setup({ check_ts = true })

	add("wakatime/vim-wakatime")
	add("vyfor/cord.nvim")

	require("which-key").setup({})
	require("config.keymaps")
	require("config.autocmds")
end)
