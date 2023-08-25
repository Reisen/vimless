return function(config)
    if type(config.plugins.ccc) == 'boolean' and not config.plugins.ccc then
        return {}
    end

    return {
        'uga-rosa/ccc.nvim',
        config = function()
            if config.plugins.ccc and type(config.plugins.ccc) == 'function' then
                config.plugins.ccc()
                return
            end

            local opts = {}

            if config.plugins.ccc and type(config.plugins.ccc) == 'table' then
                opts = vim.tbl_deep_extend('force', opts, config.plugins.ccc)
            end

            require 'ccc'.setup(opts)
        end
    }
end


