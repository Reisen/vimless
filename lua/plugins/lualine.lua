return function(config)
    if type(config.plugins.lualine) == 'boolean' and not config.plugins.lualine then
        return {}
    end

    return {
        'nvim-lualine/lualine.nvim',
        dependencies = {
            { 'nvim-tree/nvim-web-devicons', lazy = true }
        },
        config = function()
            if config.plugins.lualine and type(config.plugins.lualine) == 'function' then
                config.plugins.lualine()
                return
            end

            local opts = {
                options = {
                    theme = '16color'
                }
            }

            if config.plugins.lualine and type(config.plugins.lualine) == 'table' then
                opts = vim.tbl_deep_extend('force', opts, config.plugins.lualine)
            end

            require 'lualine'.setup(opts)
        end
    }
end
