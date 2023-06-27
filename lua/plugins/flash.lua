return function(config)
    if type(config.plugins.flash) == 'boolean' and not config.plugins.flash then
        return {}
    end

    return {
        'folke/flash.nvim',
        keys = {
            {
                'z',
                mode = { 'n', 'x', 'o' },
                function() require 'flash'.jump() end,
            },
            {
                'Z',
                mode = { 'n', 'x', 'o' },
                function() require 'flash'.treesitter() end,
            }
        },
        config = function()
            if config.plugins.flash and type(config.plugins.flash) == 'function' then
                config.plugins.flash()
                return
            end

            local opts = {
                sort_order = 'directories_first',
            }

            if config.plugins.flash and type(config.plugins.flash) == 'table' then
                opts = vim.tbl_extend('force', opts, config.plugins.flash)
            end

            require 'flash'.setup(opts)
        end
    }
end

