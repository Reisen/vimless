---@diagnostic disable-next-line: unused-local
return function(config)
    if type(config.plugins.auto_session) == 'boolean' and not config.plugins.auto_session then
        return {}
    end

    return {
        'rmagatti/auto-session',
        config = function()
            if config.plugins.auto_session and type(config.plugins.auto_session) == 'function' then
                config.plugins.auto_session()
                return
            end

            local opts = {
                previewer = false,
                winblend  = 0,
            }

            if config.plugins.auto_session and type(config.plugins.auto_session) == 'table' then
                opts = vim.tbl_deep_extend('force', opts, config.plugins.auto_session)
            end

            require('auto-session').setup(opts)
        end
    }
end
