return function(config)
    if type(config.plugins.onedark) == 'boolean' and not config.plugins.onedark then
        return {}
    end

    return {
        'navarasu/onedark.nvim',
        config = function()
            if config.plugins.onedark and type(config.plugins.onedark) == 'function' then
                config.plugins.onedark()
                return
            end

            local opts = {
                style         = 'deep',
                term_colors   = true,
                ending_tildes = false,
                diagnostics   = {
                    darker     = true,
                    undercurl  = true,
                    background = true,
                },
            }

            if config.plugins.onedark and type(config.plugins.onedark) == 'table' then
                opts = vim.tbl_deep_extend('force', opts, config.plugins.onedark)
            end

            require 'onedark'.setup(opts)
            require 'onedark'.load()
        end

    }
end
