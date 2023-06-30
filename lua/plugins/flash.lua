return function(config)
    if type(config.plugins.flash) == 'boolean' and not config.plugins.flash then
        return {}
    end

    return {
        'folke/flash.nvim',
        keys = {
            { 's', mode = { 'n', 'x', 'o' }, function() require 'flash'.jump() end, desc = 'Flash' },
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
                jump  = { nohlsearch = true },
                label = {
                    after  = false,
                    before = {0, 2},
                },
                modes = {
                    search = {
                        label = {
                            after  = true,
                            before = false,
                        }
                    }
                }
            }

            if config.plugins.flash and type(config.plugins.flash) == 'table' then
                opts = vim.tbl_extend('force', opts, config.plugins.flash)
            end

            require 'flash'.setup(opts)
        end
    }
end

