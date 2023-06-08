return function(config)
    if type(config.plugins.rust) == 'boolean' and not config.plugins.rust then
        return {}
    end

    -- Enable Rust.vim's automatic Rustfmt on save.
    vim.g.rustfmt_autosave = 1

    -- Autocommand that overrides doc-comment colours with comment colours.
    vim.cmd [[
        augroup rust-comment-hl
        autocmd FileType rust hi link rustCommentLineDoc rustCommentLine
        augroup END
    ]]

    return {
        'simrat39/rust-tools.nvim',
        requires = {
            'SmiteshP/nvim-navic',
            'rust-lang/rust.vim',
            'nvim-lua/plenary.nvim' ,
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

            require 'rust-tools'.setup(opts.rust_tools)
            require 'crates'.setup(opts.crates)
        end
    }
end
