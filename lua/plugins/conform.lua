return function(config)
    if type(config.plugins.conform) == 'boolean' and not config.plugins.conform then
        return {}
    end

    return {
        'stevearc/conform.nvim',
        config = function()
            if config.plugins.conform and type(config.plugins.conform) == 'function' then
                config.plugins.conform()
                return
            end

            local opts = {
                formatters_by_ft = {
                    lua        = { 'stylua' },
                    go         = { 'gofmt' },
                    python     = { 'black' },
                    javascript = { 'prettier' },
                },
            }

            if config.plugins.conform and type(config.plugins.conform) == 'table' then
                opts = vim.tbl_deep_extend('force', opts, config.plugins.conform)
            end

            require('conform').setup(opts)
        end,
    }
end
