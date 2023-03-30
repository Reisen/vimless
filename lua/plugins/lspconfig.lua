return function(use)
    -- Override LSP Configuration.
    vim.diagnostic.config({
        virtual_text  = true,
        underline     = false,
        virtual_lines = { only_current_line = false, }
    })

    -- LSP Configuration.
    use { 'neovim/nvim-lspconfig',
        requires = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'SmiteshP/nvim-navic',
        },
        config = function()
            -- Load CMP capabilities for LSP.
            local capabilities = require'cmp_nvim_lsp'.default_capabilities()

            -- Setup Mason before LSPConfig.
            require 'mason'.setup {}
            require 'mason-lspconfig'.setup {}
            require 'mason-lspconfig'.setup_handlers {
                -- Provide an automated handler for LSP servers that supports
                -- navic automatically.
                function(server_name)
                    require 'lspconfig'[server_name].setup {
                        capabilities = capabilities,
                        on_attach    = function(client, buffer)
                            require 'nvim-navic'.attach(
                                client,
                                buffer
                            )
                        end,
                    }
                end,

                -- Lua requires extra handling to configure the expected
                -- runtime, diagnostics and library paths. So we sadly can't
                -- just use the default handler above.
                lua_ls = function()
                    require 'lspconfig'.lua_ls.setup {
                        capabilities = capabilities,
                        on_attach    = function(client, buffer)
                            require 'nvim-navic'.attach(
                                client,
                                buffer
                            )
                        end,

                        settings = {
                            Lua = {
                                runtime     = { version = 'LuaJIT', },
                                workspace   = { library = vim.api.nvim_get_runtime_file('', true), },
                                telemetry   = { enable = false, },
                                diagnostics = {
                                    globals = { 'use', 'vim' },
                                },
                            },
                        },
                    }
                end,
            }

            -- Sign Overrides
            local signs = {
                Error = "E",
                Warn  = "W",
                Hint  = "H",
                Info  = "I",
            }

            for type, icon in pairs(signs) do
                local hl = 'DiagnosticSign' .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
            end
        end
    }

    -- Prettier LSP Diagnostics
    -- use { 'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
    --     config = function()
    --         require 'lsp_lines'.setup()
    --     end,
    -- }

    -- Null LSP Diagnostics
    use { 'jose-elias-alvarez/null-ls.nvim',
        config = function()
            require 'null-ls'.setup({
                sources = {
                    require 'null-ls'.builtins.code_actions.gitsigns,
                },
            })
        end,
    }
end
