return function(config)
    if type(config.plugins.lspconfig) == 'boolean' and not config.plugins.lspconfig then
        return {}
    end

    -- Override LSP Configuration.
    vim.diagnostic.config({
        virtual_text  = true,
        underline     = false,
        virtual_lines = { only_current_line = false },
        right_align   = true,
    })

    -- LSP Configuration.
    return {
        'neovim/nvim-lspconfig',
        dependencies = {
            'SmiteshP/nvim-navic',
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'nvim-lua/plenary.nvim',
        },
        config = function()
            if config.plugins.lspconfig and type(config.plugins.lspconfig) == 'function' then
                config.plugins.lspconfig()
                return
            end

            vim.cmd [[
                set winbar+=\ \ %{%v:lua.require'nvim-navic'.get_location()%}
            ]]

            -- Setup Mason before LSPConfig.
            require 'mason'.setup {}
            require 'mason-lspconfig'.setup {}
            require 'mason-lspconfig'.setup_handlers {
                -- Provide an default handler for LSP servers. Whenever Mason installs
                -- a server it will automatically use this call to setup those servers
                -- so they don't have to be listed here manually.
                function(server_name)
                    require 'lspconfig'[server_name].setup {
                        on_attach    = function(client, buffer)
                            -- client.server_capabilities.semanticTokensProvider = nil
                            require 'nvim-navic'.attach(
                                client,
                                buffer
                            )
                        end,
                    }
                end,

                -- Disable Rust Analyzer Setup so that rust-tools.nvim can handle it
                -- instead, rust-tools is much more integrated.
                rust_analyzer = function()
                end,

                -- Lua requires extra handling to configure the expected runtime and
                --  library paths. So we sadly can't rely on a default handler to
                --  set these up for us.
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
