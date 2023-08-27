return function(config)
    if type(config.plugins.hardtime) == 'boolean' and not config.plugins.hardtime then
        return {}
    end

    return {
        'm4xshen/hardtime.nvim',
        dependencies = {
            'MunifTanjim/nui.nvim',
            'nvim-lua/plenary.nvim'
        },
        config       = function()
            if config.plugins.hardtime and type(config.plugins.hardtime) == 'function' then
                config.plugins.hardtime()
                return
            end

            local opts = {
                max_count       = 1,
                restricted_keys = {
                   ["h"]     = { "n", "x" },
                   ["j"]     = { "n", "x" },
                   ["k"]     = { "n", "x" },
                   ["l"]     = { "n", "x" },
                   ["+"]     = { "n", "x" },
                   ["gj"]    = { "n", "x" },
                   ["gk"]    = { "n", "x" },
                   ["<CR>"]  = { "n", "x" },
                   ["<C-M>"] = { "n", "x" },
                   ["<C-N>"] = { "n", "x" },
                   ["<C-P>"] = { "n", "x" },
                },
            }

            if config.plugins.hardtime and type(config.plugins.hardtime) == 'table' then
                opts = vim.tbl_deep_extend('force', opts, config.plugins.hardtime)
            end

            require 'hardtime'.setup(opts)
        end
    }
end
