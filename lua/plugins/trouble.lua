return function(use)
    use { 'folke/trouble.nvim',
        config = function()
            require 'trouble'.setup {
            }
        end
    }
end
