return function(use)
    use { 'ThePrimeagen/harpoon',
        requires = { 'nvim-lua/plenary.nvim' },
        config   = function()
            require 'harpoon'.setup {
                menu = {
                    width = 120,
                }
            }
        end
    }
end
