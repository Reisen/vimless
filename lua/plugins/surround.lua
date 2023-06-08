return function(config)
    if type(config.plugins.surround) == 'boolean' and not config.plugins.surround then
        return {}
    end

    return {
        'tpope/vim-surround',
        config = function()
            if config.plugins.surround and type(config.plugins.surround) == 'function' then
                config.plugins.surround()
                return
            end
        end
    }
end

