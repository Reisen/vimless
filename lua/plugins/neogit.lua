return function(config)
    if type(config.plugins.neogit) == 'boolean' and not config.plugins.neogit then
        return {}
    end

    return {
        'CKolkey/neogit',
        config = function()
            if config.plugins.neogit and type(config.plugins.neogit) == 'function' then
                config.plugins.neogit()
                return
            end

            local opts = {}

            if config.plugins.neogit and type(config.plugins.neogit) == 'table' then
                opts = vim.tbl_extend('force', opts, config.plugins.neogit)
            end

            require 'neogit'.setup(opts)
        end
    }
end