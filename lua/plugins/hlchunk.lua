return function(config)
    if type(config.plugins.hlchunk) == 'boolean' and not config.plugins.hlchunk then
        return {}
    end

    return {
        'shellRaining/hlchunk.nvim',
        config = function()
            if config.plugins.hlchunk and type(config.plugins.hlchunk) == 'function' then
                config.plugins.hlchunk()
                return
            end

            local opts = {
                line_num = { enable = false },
                indent   = { enable = true, chars = { ' ' } },
                blank    = { enable = true, chars = { ' ' } },
                chunk    = {
                    enable = true,
                    style  = { 1 }
                },
            }

            if config.plugins.hlchunk and type(config.plugins.hlchunk) == 'table' then
                opts = vim.tbl_extend('force', opts, config.plugins.hlchunk)
            end

            require 'hlchunk'.setup(opts)
        end
    }
end

