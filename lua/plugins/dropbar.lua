return function(config)
    if type(config.plugins.dropbar) == 'boolean' and not config.plugins.dropbar then
        return {}
    end

    return {
        'Bekaboo/dropbar.nvim',
        config = function()
            if config.plugins.dropbar and type(config.plugins.dropbar) == 'function' then
                config.plugins.dropbar()
                return
            end

            local opts = {
                bar = {
                    padding = {
                        left  = 0,
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

            if config.plugins.dropbar and type(config.plugins.dropbar) == 'table' then
                opts = vim.tbl_extend('force', opts, config.plugins.dropbar)
            end

            require 'dropbar'.setup(opts)
        end
    }
end
