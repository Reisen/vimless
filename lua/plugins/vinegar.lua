return function(config)
    if type(config.plugins.vinegar) == 'boolean' and not config.plugins.vinegar then
        return {}
    end

    return {
        'tpope/vim-vinegar',
        config = function()
            if config.plugins.vinegar and type(config.plugins.vinegar) == 'function' then
                config.plugins.vinegar()
                return
            end
        end
    }
end

