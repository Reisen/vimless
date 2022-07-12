return function(use)
    use { 'nvim-lualine/lualine.nvim',
        config = function()
            require 'lualine'.setup {
                options = {
                    theme = 'dracula',
                }
            }
        end
    }
end
