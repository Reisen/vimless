return function(config)
    if type(config.plugins.hydra) == 'boolean' and not config.plugins.hydra then
        return {}
    end

    return {
        'anuvyklack/hydra.nvim',
        priority     = 900, -- Load Early.
        dependencies = { 'nvim-lua/plenary.nvim', },
        config = function()
            if config.plugins.hydra and type(config.plugins.hydra) == 'function' then
                config.plugins.hydra()
                return
            end

            require('keymap'):setup(config)
        end
    }
end
