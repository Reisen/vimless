return function(config)
    if type(config.plugins.fzf_lua) == 'boolean' and not config.plugins.fzf_lua then
        return {}
    end

    return {
        'ibhagwan/fzf-lua',
        config = function()
            if config.plugins.fzf_lua and type(config.plugins.fzf_lua) == 'function' then
                config.plugins.fzf_lua()
                return
            end

            local opts = {}

            if config.plugins.fzf_lua and type(config.plugins.fzf_lua) == 'table' then
                opts = vim.tbl_deep_extend('force', opts, config.plugins.fzf_lua)
            end

            require 'fzf-lua'.setup(opts)
        end
    }
end

