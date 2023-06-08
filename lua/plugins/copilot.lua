return function(config)
    if type(config.plugins.copilot) == 'boolean' and not config.plugins.copilot then
        return {}
    end

    return {
        'github/copilot.vim',
        config = function()
            if config.plugins.copilot and type(config.plugins.copilot) == 'function' then
                config.plugins.copilot()
                return
            end
        end
    }
end

