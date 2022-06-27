return function(use)
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-nvim-lsp-signature-help'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/cmp-calc'

    use { 'hrsh7th/nvim-cmp',
        config = function()
            require 'cmp'.setup {
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'path' },
                    { name = 'buffer' },
                    { name = 'calc' },
                    { name = 'cmdline' },
                    { name = 'nvim_lsp_signature_help' },
                }
            }
        end
    }
end
