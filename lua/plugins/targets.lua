return function(config)
    if type(config.plugins.targets) == 'boolean' and not config.plugins.targets then
        return {}
    end

    return {
        'wellle/targets.vim',
        config = function()
            if config.plugins.targets and type(config.plugins.targets) == 'function' then
                config.plugins.targets()
                return
            end
        end
    }
end
