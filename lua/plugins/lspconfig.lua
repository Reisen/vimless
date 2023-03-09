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

            -- Lua Language Server.
            require 'lspconfig'.lua_ls.setup {
                capabilities = capabilities,
                on_attach    = function(client, buffer)
                    require 'nvim-navic'.attach(
                        client,
                        buffer
                    )
                end,
                settings     = {
                    Lua = {
                        runtime = {
                            version = 'LuaJIT',
                        },
                        diagnostics = {
                            globals = { 'use', 'vim' },
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file('', true),
                        },
                        telemetry = {
                            enable = false,
                        },
                    },
                },
            }

            -- C/C++ Language Server
            require 'lspconfig'.clangd.setup {
                capabilities = capabilities,
                on_attach    = function(client, buffer)
                    require 'nvim-navic'.attach(
                        client,
                        buffer
                    )
                end,
            }

            -- Go Language Server
            require 'lspconfig'.gopls.setup {
                capabilities = capabilities,
                on_attach    = function(client, buffer)
                    require 'nvim-navic'.attach(
                        client,
                        buffer
                    )
                end,
            }

            -- Haskell Language Server
            require 'lspconfig'.hls.setup {
                capabilities = capabilities,
                on_attach    = function(client, buffer)
                    require 'nvim-navic'.attach(
                        client,
                        buffer
                    )
                end,
            }

            -- Python Language Server.
            require 'lspconfig'.jedi_language_server.setup {
                capabilities = capabilities,
                on_attach    = function(client, buffer)
                    require 'nvim-navic'.attach(
                        client,
                        buffer
                    )
                end,
            }

            -- Nix Language Server
            require 'lspconfig'.rnix.setup {
                capabilities = capabilities,
                on_attach    = function(client, buffer)
                    require 'nvim-navic'.attach(
                        client,
                        buffer
                    )
                end,
            }

            -- Vim Language Server
            require 'lspconfig'.vimls.setup {
                capabilities = capabilities,
                on_attach    = function(client, buffer)
                    require 'nvim-navic'.attach(
                        client,
                        buffer
                    )
                end,
            }

            -- Sign Overrides
            local signs = {
                Error = " ",
                Warn  = " ",
                Hint  = " ",
                Info  = " ",
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
