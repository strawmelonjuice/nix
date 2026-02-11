return {
    {
        "stevearc/conform.nvim",
        opts = function()
            local plugin = require("lazy.core.config").plugins["conform.nvim"]
            ---@type conform.setupOpts
            local opts = {
                default_format_opts = {
                    timeout_ms = 3000,
                    async = false,
                    quiet = false,
                    lsp_format = "fallback",
                },
                formatters_by_ft = {
                    lua = { "stylua" },
                    fish = { "fish_indent" },
                    sh = { "shfmt" },
                    nix = { "nixfmt" },
                    gleam = { "gleam" },
                },
                -- The options you set here will be merged with the builtin formatters.
                -- You can also define any custom formatters here.
                ---@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride>
                formatters = {
                    injected = { options = { ignore_errors = true } },
                    -- # Example of using dprint only when a dprint.json file is present
                    -- dprint = {
                    --   condition = function(ctx)
                    --     return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
                    --   end,
                    -- },
                    --
                    -- # Example of using shfmt with extra args
                    -- shfmt = {
                    --   prepend_args = { "-i", "2", "-ci" },
                    -- },
                },
            }
            return opts
        end
    },
    {
        "saecki/crates.nvim",
        tag = "stable",
        config = function()
            require("crates").setup()
        end,
    },
    {
        "nvimdev/lspsaga.nvim",
        config = function()
            require("lspsaga").setup({})
        end,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = {
                "gleam",
                "rust",
                "erlang",
                "toml",
                "sql",
                "json",
                "lua",
                "markdown",
                "markdown_inline",
                "nil",
                "nixfmt"
            },
        },
        {
            "neovim/nvim-lspconfig",
            dependencies = {
                { "mason-org/mason.nvim", lazy = true },
                "mason-org/mason-lspconfig.nvim",
                "WhoIsSethDaniel/mason-tool-installer.nvim",
                { "j-hui/fidget.nvim",    opts = {} },
                "simrat39/rust-tools.nvim",
                { "nvim-telescope/telescope.nvim", tag = "0.1.8" },
                "Saghen/blink.cmp",
            },
            config = function()
                local lspconfig = require("lspconfig")
                local capabilities = vim.lsp.protocol.make_client_capabilities()
                -- capabilities = vim.tbl_deep_extend('force', {}, capabilities, require('cmp_nvim_lsp').default_capabilities()) -- Deze regel is niet meer nodig

                local servers = {
                    ['nil'] = {
                        formatting = {
                            command = { "nixfmt" },
                        },

                    },
                    lua_ls = {
                        settings = {
                            Lua = {
                                completion = {
                                    callSnipped = "Replace",
                                },
                            },
                        },
                    },
                    rust_analyzer = {
                        settings = {
                            ["rust_analyzer"] = {
                                cargo = {
                                    allFeatures = true,
                                },
                            },
                        },
                    },
                }

                require("mason").setup()

                local ensure_installed = vim.tbl_keys(servers or {})
                vim.list_extend(ensure_installed, { "stylua" })
                require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

                require("mason-lspconfig").setup({
                    ensure_installed = {},
                    automatic_installation = {},
                    handlers = {
                        function(server_name)
                            local server = servers[server_name] or {}
                            server.capabilities =
                                vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                            require("lspconfig")[server_name].setup(server)
                        end,
                    },
                })

                lspconfig.gleam.setup({
                    capabilities = capabilities,
                })
                lspconfig.rust_analyzer.setup({
                    capabilities = capabilities,
                })

                local is_windows = vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1 or vim.fn.has("win16") == 1
                local omnisharp_path = ""
                if is_windows then
                    omnisharp_path = vim.fs.normalize("~/omnisharp/OmniSharp.exe")
                else
                    omnisharp_path = vim.fs.normalize("~/omnisharp/OmniSharp")
                end

                lspconfig.omnisharp.setup({
                    cmd = { omnisharp_path, "--languageserver" },
                    filetypes = { "cs", "razor" },
                    root_dir = lspconfig.util.root_pattern("*.sln", "Directory.Build.props", ".git"),
                    capabilities = capabilities,
                    settings = {
                        FormattingOptions = {
                            EnableEditorConfigSupport = true,
                            OrganizeImports = true,
                        },
                        MsBuild = {
                            LoadProjectsOnDemand = nil,
                        },
                        RoslynExtensionsOptions = {
                            EnableImportCompletion = true,
                            AnalyzeOpenDocumentsOnly = nil,
                        },
                        Sdk = {
                            IncludePrereleases = true,
                        },
                    },
                })

                vim.api.nvim_create_autocmd("LspAttach", {
                    group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
                    callback = function(event)
                        local map = function(keys, func, desc, mode)
                            mode = mode or "n"
                            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                        end

                        map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
                        map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
                        map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
                        map("<Space>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
                        map("<Space>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
                        map(
                            "<Space>ws",
                            require("telescope.builtin").lsp_dynamic_workspace_symbols,
                            "[W]orkspace [S]ymbols"
                        )
                        map("<Space>rn", vim.lsp.buf.rename, "[R]e[n]ame")
                        map("<Space>a", vim.lsp.buf.code_action, "[C]ode [A]ction")
                        map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclartion")

                        local client = vim.lsp.get_client_by_id(event.data.client_id)
                        if
                            client
                            and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight)
                        then
                            local highlight_augroup =
                                vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = true })
                            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                                buffer = event.buf,
                                group = highlight_augroup,
                                callback = vim.lsp.buf.document_highlight,
                            })

                            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                                buffer = event.buf,
                                group = highlight_augroup,
                                callback = vim.lsp.buf.clear_references,
                            })

                            vim.api.nvim_create_autocmd({ "LspDetach" }, {
                                group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
                                callback = function(event2)
                                    vim.lsp.buf.clear_references()
                                    vim.api.nvim_clear_autocmds({
                                        group = "kickstart-lsp-highlight",
                                        buffer = event2.buf,
                                    })
                                end,
                            })
                        end
                        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                            vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })

                            map("<Space>th", function()
                                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
                            end, "[T]oggle Inlay [H]ints")
                        end
                    end,
                })
            end,
        },
    },
}
