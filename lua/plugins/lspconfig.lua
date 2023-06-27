return function(config)
    if type(config.plugins.lspconfig) == 'boolean' and not config.plugins.lspconfig then
        return {}
    end

    -- Override LSP Configuration.
    vim.diagnostic.config({
        underline        = false,                         -- underline LSP diagnostics
        update_in_insert = false,                         -- do not update diagnostics in insert mode
        virtual_lines    = { only_current_line = false }, -- show virtual lines
        right_align      = true,                          -- right-align the diagnostics
        severity_sort    = true,                          -- sort the diagnostics by severity
        virtual_text     = true,                          -- show virtual text
    })

    -- LSP Configuration.
    return {
        'neovim/nvim-lspconfig',
        dependencies = {
            'SmiteshP/nvim-navic',
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'nvim-lua/plenary.nvim',
            { 'folke/neoconf.nvim', cmd = 'Neoconf', config = true },
        },
        config = function()
            if config.plugins.lspconfig and type(config.plugins.lspconfig) == 'function' then
                config.plugins.lspconfig()
                return
            end

            local opts = {
                mason = {
                    ui = {
                        border = 'single',
                        width  = 0.999,
                        height = 0.999,
                    }
                },

                mason_lspconfig = {
                }
            }

            if config.plugins.lspconfig and type(config.plugins.lspconfig) == 'table' then
                opts = vim.tbl_deep_auto_sessionextend('force', opts, config.plugins.lspconfig)
            end

            vim.cmd [[
                set winbar+=\ \ %{%v:lua.require'nvim-navic'.get_location()%}
            ]]

            -- Setup Mason before LSPConfig.
            require 'mason'.setup(opts.mason)
            require 'mason-lspconfig'.setup(opts.mason_lspconfig)
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

                            -- If the server supports inlay hints, then enable them.
                            if client.server_capabilities and client.server_capabilities.inlayHintsProvider then
                                vim.lsp.buf.inlay_hint(buffer, true)
                            end
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
