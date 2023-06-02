return function(use)
    use { 'nvim-neo-tree/neo-tree.nvim',
        requires = {
            'kyazdani42/nvim-web-devicons',
            'MunifTanjim/nui.nvim',
        },
        config   = function()
            require 'neo-tree'.setup {
                filesystem = {
                    hijack_netrw_behavior = 'disabled',
                },

                source_selector = {
                    winbar = false,
                }
            }
        end
    }
end
