return function(config)
    if type(config.plugins.dirbuf) == 'boolean' and not config.plugins.dirbuf then
        return {}
    end

    return {
        'elihunter173/dirbuf.nvim',
        config = function()
            if config.plugins.dirbuf and type(config.plugins.dirbuf) == 'function' then
                config.plugins.dirbuf()
                return
            end

            local opts = {
                sort_order = 'directories_first',
            }

            if config.plugins.dirbuf and type(config.plugins.dirbuf) == 'table' then
                opts = vim.tbl_deep_extend('force', opts, config.plugins.dirbuf)
            end

            require 'dirbuf'.setup(opts)
        end
    }
end
