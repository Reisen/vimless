return function(use)
    use { 'echasnovski/mini.nvim',
        config = function()
            require 'mini.comment'.setup {}
            require 'mini.map'.setup     {
                integrations = {
                    require 'mini.map'.gen_integration.builtin_search(),
                    require 'mini.map'.gen_integration.diagnostic(),
                    require 'mini.map'.gen_integration.gitsigns(),
                },
                symbols = {
                    encode      = require 'mini.map'.gen_encode_symbols.dot('4x2'),
                    scroll_line = '  ',
                    scroll_view = '  ',
                },
                window = {
                    width                  = 14,
                    winblend               = 100,
                    show_integration_count = false,
                },
            }
        end
    }
end
