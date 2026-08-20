vim.g.mapleader = " "
vim.g.maplocalleader = " "
local colourscheme_light = "dayfox"
local colourscheme_dark = "tokyonight-night"
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
	add("https://github.com/folke/tokyonight.nvim")
	add("https://github.com/EdenEast/nightfox.nvim")
	add("https://github.com/nvim-tree/nvim-web-devicons")
	add("https://github.com/folke/which-key.nvim")
	add("https://github.com/nvim-telescope/telescope.nvim")
	add("https://github.com/nvim-lua/plenary.nvim")
	add("https://github.com/nvim-lualine/lualine.nvim")
	add("https://github.com/hiattp/splitwise.nvim")
	add("https://github.com/swaits/lazyjj.nvim")
	add("https://github.com/kdheepak/lazygit.nvim")
	add("https://github.com/neovim/nvim-lspconfig")
	add("https://github.com/stevearc/conform.nvim")
	add("https://github.com/nvim-lua/plenary.nvim")
	add("https://github.com/windwp/nvim-autopairs")

	local hour = tonumber(os.date("%H"))
	local is_dark = (hour < 6 or hour >= 19)
	local theme = is_dark and colourscheme_dark or colourscheme_light

	vim.o.termguicolors = true
	vim.o.background = is_dark and "dark" or "light"
	vim.cmd.colorscheme(theme)
	require("which-key").setup({})
	vim.keymap.set("n", "<C-space>l", function()
		vim.o.background = "light"
		vim.cmd.colorscheme(colourscheme_light)
	end, { desc = "Switch to light mode theme (" .. colourscheme_light .. ")" })
	vim.keymap.set("n", "<C-space>d", function()
		vim.o.background = "dark"
		vim.cmd.colorscheme(colourscheme_dark)
	end, { desc = "Switch to dark mode theme (" .. colourscheme_dark .. ")" })
end)

later(function()
	require("config.keymaps")
	require("plugins.telescope")
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

	-- 	add("folke/snacks.nvim")
	-- 	require("snacks").setup({
	-- 		indent = {
	-- 			enabled = true,
	-- 			char = "╎",
	-- 			scope = {
	-- 				enabled = true,
	-- 				char = "│",
	-- 			},
	-- 		},
	-- 		dashboard = {
	-- 			enabled = true,
	-- 			sections = {
	-- 				{ section = "header", padding = 5 }, -- Alleen je mooie ASCII art
	-- 			},
	-- 			preset = {
	-- 				header = [[
	--          ===================================================================
	--          -------------------------   Mar's Nvim!   -------------------------
	--          ===================================================================
	--
	--                     Welcome! It's time to start doing stuff! :3
	-- ]],
	-- 			},
	-- 		},
	-- 		picker = { enabled = true },
	-- 		explorer = { enabled = true },
	-- 	})

	require("plugins.lualine")
	add({
		source = "Saghen/blink.cmp",
		checkout = "v1",
	})

	require("blink.cmp").setup({
		keymap = {
			-- thank you ollie https://git.ollie.earth/ollie/nvim/src/commit/a2dace525c23d5bec9d85b65f14918cb6cc1fca9/lua/plugins/blink-cmp.lua#L8
			preset = "none",
			["<C-k>"] = { "select_prev" },
			["<C-j>"] = { "select_next" },
			-- scroll docs
			["<C-b>"] = {
				function(cmp)
					cmp.scroll_documentation_up(4)
				end,
			},
			["<C-f>"] = {
				function(cmp)
					cmp.scroll_documentation_down(4)
				end,
			},
			-- confirm selection
			["<C-Enter>"] = { "select_and_accept" },
		},

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

	require("nvim-autopairs").setup({ check_ts = true })
	require("splitwise").setup({
		max_columns = 3, -- Default:2
		max_rows = 1, -- Default:2
	})

	add("https://github.com/wakatime/vim-wakatime")
	add("https://github.com/vyfor/cord.nvim")

	require("config.autocmds")
end)
