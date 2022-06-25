return function(use)
    use { 'sindrets/diffview.nvim',
        requires = 'nvim-lua/plenary.nvim',
        config   = function()
            require 'diffview'.setup {
                enhanced_diff_hl = true
            }
        end
    }
end
