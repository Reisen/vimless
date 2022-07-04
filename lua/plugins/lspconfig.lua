return function(use)
    use { 'neovim/nvim-lspconfig',
        config = function()
            -- Load CMP capabilities for LSP.
            local capabilities = require('cmp_nvim_lsp').update_capabilities(
                vim.lsp.protocol.make_client_capabilities()
            )

            require 'lspconfig'.sumneko_lua.setup {
                capabilities = capabilities,
                on_attach    = function(client, buffer) end,
                settings     = {
                    Lua = {
                        runtime = {
                            version = 'LuaJIT',
                        },
                        diagnostics = {
                            globals = { 'use', 'vim' },
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                        },
                        telemetry = {
                            enable = false,
                        },
                    },
                },
            }

            require 'lspconfig'.clangd.setup {
                capabilities = capabilities,
                on_attach    = function(client, buffer) end,
            }

            require 'lspconfig'.hls.setup {
                capabilities = capabilities,
                on_attach    = function(client, buffer) end,
            }

            require 'lspconfig'.jedi_language_server.setup {
                capabilities = capabilities,
                on_attach    = function(client, buffer) end,
            }

            -- Override LSP Configuration.
            vim.diagnostic.config({
                virtual_text = false,
            })
        end
    }
end
