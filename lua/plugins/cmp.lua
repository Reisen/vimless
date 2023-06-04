return function(use)
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-nvim-lsp-signature-help'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/cmp-calc'
    use 'hrsh7th/cmp-vsnip'
    use 'hrsh7th/vim-vsnip'
    use 'onsails/lspkind.nvim'

    use { 'hrsh7th/nvim-cmp',
        config = function()
            -- Bring cmp into scope to avoid having to constantly re-require it.
            local cmp = require 'cmp'

            cmp.setup {
                snippet = {
                    expand = function(args)
                        vim.fn["vsnip#anonymous"](args.body)
                    end,
                },

                -- Define a reasonable ordering for completion sources focused
                -- on LSP as the main source, falling back only when necessary.
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'nvim_lsp_signature_help' },
                    { name = 'path' },
                    { name = 'crates' },
                    { name = 'calc' },
                },

                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.select_prev_item(),
                    ['<C-f>'] = cmp.mapping.select_next_item(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>']  = cmp.mapping.confirm({ select = true }),
                }),

                experimental = {
                   ghost_text = false, -- Conflicts with Github Copilot.
                },

                window = {
                    completion = {
                        -- winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
                        col_offset   = -3,
                        side_padding = 0,
                    },
                },

                formatting = {
                    fields = { 'kind', 'abbr', 'menu' },
                    format = function(entry, vim_item)
                        local kind = (require 'lspkind'.cmp_format {
                            mode       = 'symbol_text',
                            maxwidth   = 50,
                            symbol_map = {
                                TypeParameter = "",
                            },
                        })(entry, vim_item)

                        local split = string.gmatch(kind.kind, '([^%s]+)')
                        kind.kind = ' ' .. split() .. ' '
                        kind.menu = ' ' .. split() .. ' '
                        return kind
                    end
                },
            }
        end
    }
end
