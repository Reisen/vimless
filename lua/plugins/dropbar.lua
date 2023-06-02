return function(use)
    use { 'Bekaboo/dropbar.nvim',
        config = function()
            require 'dropbar'.setup {
                bar = {
                    padding = {
                        left  = 6,
                        right = 0,
                    },
                },

                icons = {
                    ui = {
                        bar = {
                            left  = '',
                            right = '',
                        },
                    },
                },
            }
        end
    }
end
