return function(use)
    -- Override LSP Configuration.
    vim.diagnostic.config({
        virtual_text  = true,
        underline     = false,
        virtual_lines = { only_current_line = false },
        right_align   = true,
    })

    -- LSP Configuration.
    use { 'neovim/nvim-lspconfig',
        requires = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'nvim-lua/plenary.nvim',
        },
        config = function()
            -- Setup Mason before LSPConfig.
            require 'mason'.setup {}
            require 'mason-lspconfig'.setup {}
            require 'mason-lspconfig'.setup_handlers {
                -- Provide an automated handler for LSP servers that supports
                -- navic.
                function(server_name)
                    require 'lspconfig'[server_name].setup {
                        on_attach    = function(client)
                            client.server_capabilities.semanticTokensProvider = nil
                        end,
                        flags = {
                            allow_incremental_sync = false,
                            debounce_text_changes  = 50,
                        }
                    }
                end,

                -- Lua requires extra handling to configure the expected
                -- runtime, diagnostics and library paths. So we sadly can't
                -- just use the default handler above.
                lua_ls = function()
                    require 'lspconfig'.lua_ls.setup {
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
                Error = "●",
                Warn  = "●",
                Hint  = "●",
                Info  = "●",
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
    -- use { 'jose-elias-alvarez/null-ls.nvim',
    --     requires = {
    --         'nvim-lua/plenary.nvim',
    --     },
    --     config = function()
    --         require 'null-ls'.setup({
    --             sources = {
    --                 require 'null-ls'.builtins.code_actions.gitsigns,
    --             },
    --         })
    --     end,
    -- }
end
