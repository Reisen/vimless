return function(config)
    if type(config.plugins.mini) == 'boolean' and not config.plugins.mini then
        return {}
    end

    return {
        'echasnovski/mini.nvim',
        config = function()
            if config.plugins.mini and type(config.plugins.mini) == 'function' then
                config.plugins.mini()
                return
            end

            local opts = {
                comment = {},
                map     = {
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
                },
            }

            require 'mini.comment'.setup(opts.comment)
            require 'mini.map'.setup(opts.map)
        end
    }
end
