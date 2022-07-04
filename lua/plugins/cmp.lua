local kind_icons = {
    Text          = "",
    Method        = "",
    Function      = "",
    Constructor   = "",
    Field         = "",
    Variable      = "",
    Class         = "ﴯ",
    Interface     = "",
    Module        = "",
    Property      = "ﰠ",
    Unit          = "",
    Value         = "",
    Enum          = "",
    Keyword       = "",
    Snippet       = "",
    Color         = "",
    File          = "",
    Reference     = "",
    Folder        = "",
    EnumMember    = "",
    Constant      = "",
    Struct        = "",
    Event         = "",
    Operator      = "",
    TypeParameter = "",
}

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
            require 'cmp'.setup {
                snippet = {
                    expand = function(args)
                        vim.fn["vsnip#anonymous"](args.body)
                    end,
                },

                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'vsnip' },
                    { name = 'path' },
                    { name = 'buffer' },
                    { name = 'calc' },
                    { name = 'cmdline' },
                    { name = 'nvim_lsp_signature_help' },
                },

                mapping = require 'cmp'.mapping.preset.insert({
                    ['<C-b>']     = require 'cmp'.mapping.scroll_docs(-4),
                    ['<C-f>']     = require 'cmp'.mapping.scroll_docs(4),
                    ['<C-Space>'] = require 'cmp'.mapping.complete(),
                    ['<C-e>']     = require 'cmp'.mapping.abort(),
                    ['<CR>']      = require 'cmp'.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                }),

                window = {
                    completion = {
                        winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
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
