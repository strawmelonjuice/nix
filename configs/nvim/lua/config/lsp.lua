local lspconfig = vim.lsp.config


local servers = { "nil_ls", "rust_analyzer", "gleam", "lua_ls", "zls", "taplo", "tailwindcss", "cssls" }

for _, server in ipairs(servers) do
  local config = lspconfig[server]
  
  if config and config.default_config then
    local cmd = config.default_config.cmd
    if cmd and cmd[1] and vim.fn.executable(cmd[1]) == 1 then
      vim.lsp.enable(server)
      
    end
  end
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, args.buf)
    end
  end,
})