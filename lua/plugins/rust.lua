return function(config)
    if type(config.plugins.rust) == 'boolean' and not config.plugins.rust then
        return {}
    end

    -- Enable Rust.vim's automatic Rustfmt on save.
    vim.g.rustfmt_autosave = 1
    vim.g.rustfmt_command  = 'rustup run nightly rustfmt'

    -- Autocommand that overrides doc-comment colours with comment colours.
    vim.cmd [[
        augroup rust-comment-hl
        autocmd FileType rust hi link rustCommentLineDoc rustCommentLine
        augroup END
    ]]

    return {
        'simrat39/rust-tools.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim' ,
            'SmiteshP/nvim-navic',
            'saecki/crates.nvim',
        },
        config   = function()
            if config.plugins.rust and type(config.plugins.rust) == 'function' then
                config.plugins.rust()
                return
            end

            local opts = {
                rust_tools = {
                    server = {
                        on_attach = function(client, buffer)
                            require 'nvim-navic'.attach(
                                client,
                                buffer
                            )
                        end,

                        settings = {
                            ["rust-analyzer"] = {
                                checkOnSave = {
                                    command = 'clippy'
                                }
                            }
                        }
                    },

                    tools = {
                        crate_graph = {
                            backend = "plaintext",
                            output  = nil,
                            full    = true,
                        }
                    }
                },

                crates = {
                    text = {
                        loading    = "  Loading...",
                        version    = "  %s",
                        prerelease = "  %s",
                        yanked     = "  %s yanked",
                        nomatch    = "  Not found",
                        upgrade    = "  %s",
                        error      = "  Error fetching crate",
                    },
                    src = {
                        text = {
                            prerelease = "  pre-release ",
                            yanked     = "  yanked ",
                        },
                    },
                },
            }

            local tools  = require 'rust-tools'
            local crates = require 'crates'
            tools.setup(opts.rust_tools)
            crates.setup(opts.crates)

            local keymap = require 'keymap'

            keymap:registerLanguage('Rust',   'rust')
            keymap:registerLanguage('Crates', 'toml')

            _G.HydraMappings['Crates']['Crates'].u = { 'Update Crate',       crates.update_crate,            { exit = true }}
            _G.HydraMappings['Crates']['Crates'].U = { 'Upgrade Crate',      crates.upgrade_crate,           { exit = true }}
            _G.HydraMappings['Crates']['Crates'].i = { 'Crate Info',         crates.show_popup,              { exit = true }}
            _G.HydraMappings['Crates']['Crates'].d = { 'Crate Dependencies', crates.show_dependencies_popup, { exit = true }}
            _G.HydraMappings['Crates']['Crates'].f = { 'Crate Features',     crates.show_features_popup,     { exit = true }}
            _G.HydraMappings['Crates']['Crates'].v = { 'Crate Versions',     crates.show_versions_popup,     { exit = true }}

            _G.HydraMappings['Rust']['Rust'].k = { 'Move Item Up',    tools.move_item.move_up,               { exit = true }}
            _G.HydraMappings['Rust']['Rust'].j = { 'Move Item Down',  tools.move_item.move_down,             { exit = true }}
            _G.HydraMappings['Rust']['Rust'].e = { 'Expand Macro',    tools.expand_macro.expand_macro,       { exit = true }}
            _G.HydraMappings['Rust']['Rust'].s = { 'Parent Module',   tools.parent_module.parent_module,     { exit = true }}
            _G.HydraMappings['Rust']['Rust'].c = { 'Open Cargo.toml', tools.open_cargo_toml.open_cargo_toml, { exit = true }}
        end
    }
end
