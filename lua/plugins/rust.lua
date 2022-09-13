return function(use)
    -- Enable Rust.vim's automatic Rustfmt on save.
    vim.g.rustfmt_autosave = 1

    use { 'simrat39/rust-tools.nvim',
        requires = 'SmiteshP/nvim-navic',
        config   = function()
            require 'rust-tools'.setup {
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
            }
        end
    }

    use { 'rust-lang/rust.vim',
        config = function()
        end
    }

    use { 'saecki/crates.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
        config   = function()
            require 'crates'.setup {
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
                        prerelease = " pre-release ",
                        yanked     = " yanked ",
                    },
                },
            }
        end,
    }

    -- Autocommand that overrides doc-comment colours with comment colours.
    vim.cmd [[ 
        augroup rust-comment-hl
        autocmd FileType rust hi link rustCommentLineDoc rustCommentLine
        augroup END
    ]]
end
