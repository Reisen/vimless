return function(config)
    if type(config.plugins.centerbuf) == 'boolean' and not config.plugins.centerbuf then
        return {}
    end

    return {
        'smithbm2316/centerpad.nvim',
        config = function()
            if config.plugins.centerbuf and type(config.plugins.centerbuf) == 'function' then
                config.plugins.centerbuf()
                return
            end

            local opts = {}

            if config.plugins.centerbuf and type(config.plugins.centerbuf) == 'table' then
                opts = vim.tbl_deep_extend('force', opts, config.plugins.centerbuf)
            end

            require 'centerbuf'.setup(opts)
        end
    }
end
