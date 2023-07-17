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
            { 'folke/neodev.nvim', opts = {} },
        },
        config = function()
            if config.plugins.lspconfig and type(config.plugins.lspconfig) == 'function' then
                config.plugins.lspconfig()
                return
            end

            local opts = {
                neodev          = {},
                mason_lspconfig = {},
                mason           = {
                    ui = {
                        border = 'single',
                        width  = 0.999,
                        height = 0.999,
                    }
                },
            }

            if config.plugins.lspconfig and type(config.plugins.lspconfig) == 'table' then
                opts = vim.tbl_deep_auto_sessionextend('force', opts, config.plugins.lspconfig)
            end

            vim.cmd [[
                set winbar+=\ \ %{%v:lua.require'nvim-navic'.get_location()%}
            ]]

            -- Setup Mason before LSPConfig.
            require 'neodev'.setup(opts.neodev)
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
                            if client.server_capabilities.documentSymbolProvider then
                                require 'nvim-navic'.attach(
                                    client,
                                    buffer
                                )
                            end

                            -- If the server supports inlay hints, then enable them.
                            if client.server_capabilities.inlayHintsProvider then
                                vim.lsp.buf.inlay_hint(buffer, true)
                            end
                        end,
                    }
                end,

                -- Disable Rust Analyzer Setup so that rust-tools.nvim can handle it
                -- instead, rust-tools is much more integrated.
                rust_analyzer = function()
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

            local keymap = require 'keymap'
            local c      = require 'hydra.keymap-util'

            _G.HydraMappings['Root']['Language'].l   = { 'LSP', function() keymap:runHydra('LSP') end, { exit = true } }

            _G.HydraMappings['LSP']['Diagnostics'].l = { 'LSP', function() keymap:runHydra('LSP') end, { exit = true } }
            _G.HydraMappings['LSP']['Diagnostics'].n = { 'Next Error',  vim.diagnostic.goto_next,  {} }
            _G.HydraMappings['LSP']['Diagnostics'].p = { 'Prev Error',  vim.diagnostic.goto_prev,  {} }
            _G.HydraMappings['LSP']['Diagnostics'].l = { 'List Errors', vim.diagnostic.setloclist, { exit = true } }

            _G.HydraMappings['LSP']['Goto'].D = { 'Declaration',          vim.lsp.buf.declaration,     { exit = true }}
            _G.HydraMappings['LSP']['Goto'].K = { 'Documentation',        vim.lsp.buf.hover,           { exit = true }}
            _G.HydraMappings['LSP']['Goto'].d = { 'Definition',           vim.lsp.buf.definition,      { exit = true }}
            _G.HydraMappings['LSP']['Goto'].i = { 'Implementations',      vim.lsp.buf.implementation,  { exit = true }}
            _G.HydraMappings['LSP']['Goto'].r = { 'References',           vim.lsp.buf.references,      { exit = true }}
            _G.HydraMappings['LSP']['Goto'].t = { 'Type Definitions',     vim.lsp.buf.type_definition, { exit = true }}
            _G.HydraMappings['LSP']['Goto'].s = { 'Definition in Split',
                function()
                    -- This opens a split to the right with the cursor
                    -- in the same space. It then focuses that window,
                    -- and invokes vim.lsp.definition to go to the
                    -- file. It will then call `zt` to move it to the
                    -- top of the file.
                    vim.cmd 'wincmd v'
                    vim.cmd 'wincmd l'
                    vim.lsp.buf.definition()
                    vim.wait(50)
                    vim.cmd 'norm zt'
                end,
                { exit = true }
            }

            _G.HydraMappings['LSP']['Refactor'].a = { 'Actions',     vim.lsp.buf.code_action, { exit = true } }
            _G.HydraMappings['LSP']['Refactor'].f = { 'Format File', vim.lsp.buf.formatting,  { exit = true } }
            _G.HydraMappings['LSP']['Refactor'].R = { 'Rename',      vim.lsp.buf.rename,      { exit = true } }

            _G.HydraMappings['LSP']['Other'].m    = { 'Mason',      c.cmd('Mason'), { exit = true } }
            _G.HydraMappings['LSP']['Other']["?"] = { 'LSP Status', c.cmd('LspInfo'), { exit = true } }
            _G.HydraMappings['LSP']['Other'].q    = { 'Quit',       function() end, { exit = true } }
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
