return {
    -- 1. FORMATTING
    {
        "stevearc/conform.nvim",
        opts = {
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
            formatters = {
                injected = { options = { ignore_errors = true } },
            },
        },
    },

    -- 2. RUST CRATES
    {
        "saecki/crates.nvim",
        tag = "stable",
        event = { "BufRead Cargo.toml" },
        opts = {},
    },

    -- 3. LSPSaga
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

    -- 4. TREESITTER
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            if type(opts.ensure_installed) == "table" then
                vim.list_extend(opts.ensure_installed, {
                    "gleam", "rust", "erlang", "typescript", "nix",
                    "toml", "sql", "json", "lua", "markdown",
                    "markdown_inline", "css"
                })
            end
        end,
    },

    -- 5. MASON (Tool Installer)
    -- install the tools that aren't LSPs (formatters/linters)
    {
        "mason-org/mason.nvim",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            vim.list_extend(opts.ensure_installed, {
                "shfmt",
            })
        end,
    },

    -- 6. LSP CONFIG
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                -- Nix
                nil_ls = {
                    -- Installed in neovim.nix

                    mason = false,
                    command = "nil",
                    formatting = { command = { "nixfmt" } },
                },

                -- Web styling
                -- Tailwind classes
                tailwindcss = {},
                -- CSS
                cssls = {},

                -- Markdown
                markdown_oxide = {
                    -- Installed in neovim.nix

                    mason = false
                },

                -- Lua
                lua_ls = {
                    -- Installed in neovim.nix

                    mason = false,
                    settings = {
                        Lua = {
                            completion = { callSnippet = "Replace" },
                        },
                    },
                },

                -- Rust
                rust_analyzer = {
                    settings = {
                        ["rust-analyzer"] = {
                            cargo = { allFeatures = true },
                        },
                    },
                },

                -- Gleam
                gleam = {},

                -- TOML
                taplo = {
                    -- Installed in neovim.nix

                    mason = false
                },

                -- Zig
                zls = {},

                -- Web linter-formatter
                biome = {
                    -- Installed in neovim.nix

                    mason = false
                },

                -- Web linter-formatter
                prettier = {
                    -- Installed in neovim.nix

                    mason = false
                },

                -- Lua
                stylua = {
                    -- Installed in neovim.nix

                    mason = false,
                },

                -- Inclusivity linter
                woke = {
                    -- Installed in neovim.nix

                    mason = false,
                },

                -- AST-grep
                ['ast-grep'] = {
                    -- Installed in neovim.nix

                    mason = false,
                },
            },
        },
    },
}
