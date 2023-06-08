return function(config)
    if type(config.plugins.quickscope) == 'boolean' and not config.plugins.quickscope then
        return {}
    end

    return {
        'unblevable/quick-scope',
        config = function()
            if config.plugins.quickscope and type(config.plugins.quickscope) == 'function' then
                config.plugins.quickscope()
                return
            end
        end
    }
end

