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

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

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

                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'vsnip' },
                    { name = 'path' },
                    { name = 'buffer' },
                    { name = 'calc' },
                    { name = 'cmdline' },
                    { name = 'nvim_lsp_signature_help' },
                },

                mapping = cmp.mapping.preset.insert({
                    ['<C-b>']     = cmp.mapping.scroll_docs(-4),
                    ['<C-f>']     = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>']     = cmp.mapping.abort(),
                    ['<CR>']      = cmp.mapping.confirm({ select = true }),
                    ['<Tab>']     = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif vim.fn["vsnip#available"](1) == 1 then
                            vim.api.nvim_feedkeys(
                                vim.api.nvim_replace_termcodes("<Plug>(vsnip-expand-or-jump)", true, true, true),
                                "",
                                true
                            )
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            return fallback()
                        end
                    end)
                }),

                experimental = {
                    ghost_text = false, -- Conflicts with Github Copilot.
                },

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
