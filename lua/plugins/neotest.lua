return function(config)
    if type(config.plugins.neotest) == 'boolean' and not config.plugins.neotest then
        return {}
    end

    return {
        'nvim-neotest/neotest',
        dependencies = {
            'rouge8/neotest-rust',
            'nvim-lua/plenary.nvim',
            'nvim-treesitter/nvim-treesitter',
            'antoinemadec/FixCursorHold.nvim'
        },
        config = function()
            if config.plugins.neotest and type(config.plugins.neotest) == 'function' then
                config.plugins.neotest()
                return
            end

            local opts = {
                adapters = {
                    require('neotest-rust')
                }
            }

            if config.plugins.neotest and type(config.plugins.neotest) == 'table' then
                opts = vim.tbl_extend('force', opts, config.plugins.neotest)
            end

            require 'neotest'.setup(opts)
        end
    }
end
