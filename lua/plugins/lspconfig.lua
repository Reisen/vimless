return function(use)
    use { 'neovim/nvim-lspconfig',
        config = function()
            require 'lspconfig'.sumneko_lua.setup {
                on_attach = function(client, buffer)
                end,

                settings = {
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
                on_attach = function(client, buffer)
                end,
            }

            require 'lspconfig'.hls.setup {
                on_attach = function(client, buffer)
                end,

                handlers = {
                    ["textDocument/publishDiagnostics"] = vim.lsp.with(
                        vim.lsp.diagnostic.on_publish_diagnostics, {
                            virtual_text = false
                        }
                    ),
                },

            }

            require 'lspconfig'.jedi_language_server.setup {
                on_attach = function(client, buffer)
                end,
            }

            -- Override LSP Configuration.
            vim.diagnostic.config({
                virtual_text = false,
            })
        end
    }
end
