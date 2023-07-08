return function(config)
    if type(config.plugins.fidget) == 'boolean' and not config.plugins.fidget then
        return {}
    end

    return {
        'j-hui/fidget.nvim',
        branch = 'legacy',
        config = function()
            if config.plugins.fidget and type(config.plugins.fidget) == 'function' then
                config.plugins.fidget()
                return
            end

            local opts = {
                text = {
                    spinner = 'arc',
                }
            }

            if config.plugins.fidget and type(config.plugins.fidget) == 'table' then
                opts = vim.tbl_extend('force', opts, config.plugins.fidget)
            end

            require 'fidget'.setup(opts)
        end,
    }
end
