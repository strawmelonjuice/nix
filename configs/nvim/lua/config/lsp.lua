local servers = { "nil_ls", "rust_analyzer", "gleam", "lua_ls", "zls", "taplo", "tailwindcss", "cssls" }

for _, server in ipairs(servers) do
	local config = vim.lsp.config[server]

	-- It failed to load w my careful approach so here we go just enabling all of em like yeet
	vim.lsp.enable(server)

	if config and config.default_config then
		local cmd = config.default_config.cmd
		if cmd and cmd[1] and vim.fn.executable(cmd[1]) == 1 then
			vim.lsp.config(server, {
				root_dir = vim.fs.root(0, { ".git", "Cargo.toml", "package.json", "flake.nix" }) or vim.fn.getcwd(),
			})
			vim.lsp.enable(server)
		end
	end
	local config = vim.lsp.config[server]

	if config and config.default_config then
		local cmd = config.default_config.cmd
		if cmd and cmd[1] and vim.fn.executable(cmd[1]) == 1 then
			vim.lsp.enable(server)
		end
	end
end

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if
			client
			-- and client.supports_method("textDocument/completion")
		then
			vim.lsp.completion.enable(true, client.id, args.buf)
		end
	end,
})
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client.supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, args.buf)
		end
	end,
})

