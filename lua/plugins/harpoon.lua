return function(config)
    if type(config.plugins.harpoon) == 'boolean' and not config.plugins.harpoon then
        return {}
    end

    return {
        'ThePrimeagen/harpoon',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config       = function()
            if config.plugins.harpoon and type(config.plugins.harpoon) == 'function' then
                config.plugins.harpoon()
                return
            end

            local opts = {
                menu = {
                    width = 120,
                }
            }

            if config.plugins.harpoon and type(config.plugins.harpoon) == 'table' then
                opts = vim.tbl_deep_extend('force', opts, config.plugins.harpoon)
            end

            require 'harpoon'.setup(opts)
        end
    }
end
