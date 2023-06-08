return function(config)
    if type(config.plugins.fugitive) == 'boolean' and not config.plugins.fugitive then
        return {}
    end

    return {
        'tpope/vim-fugitive',
        config = function()
            if config.plugins.fugitive and type(config.plugins.fugitive) == 'function' then
                config.plugins.fugitive()
                return
            end
        end
    }
end

