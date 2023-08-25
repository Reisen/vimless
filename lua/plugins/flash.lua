return function(config)
    if type(config.plugins.flash) == 'boolean' and not config.plugins.flash then
        return {}
    end

    return {
        'folke/flash.nvim',
        lazy = false,
        keys = {
            { 's', mode = { 'n', 'x', 'o' }, function() require 'flash'.jump({ search = { max_length = 2 } }) end, desc = 'Flash' },
            { 'S', mode = { 'n', 'x', 'o' }, function() require 'flash'.treesitter() end, desc = 'Flash Treesitter' },
            { 'r', mode = { 'o'           }, function() require 'flash'.remote() end, 'Flash Remote' },
            { 'R', mode = { 'x', 'o'      }, function() require 'flash'.treesitter_search() end, 'Flash Treesitter Search' },
        },
        config = function()
            if config.plugins.flash and type(config.plugins.flash) == 'function' then
                config.plugins.flash()
                return
            end

            local opts = {
                jump   = { nohlsearch = true },
                search = {},
                label = {
                    uppercase = false,
                    after     = false,
                    before    = {0, 2},
                    reuse     = 'all',
                },
                modes = {
                    search = {
                        max_length = nil,
                        search     = { max_length = nil },
                        label      = {
                            after  = true,
                            before = false,
                        }
                    }
                }
            }

            if config.plugins.flash and type(config.plugins.flash) == 'table' then
                opts = vim.tbl_deep_extend('force', opts, config.plugins.flash)
            end

            require 'flash'.setup(opts)
        end
    }
end

