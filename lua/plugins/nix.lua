return function(config)
    if type(config.plugins.nix) == 'boolean' and not config.plugins.nix then
        return {}
    end

    return {
        'LnL7/vim-nix',
        config = function()
            if config.plugins.nix and type(config.plugins.nix) == 'function' then
                config.plugins.nix()
                return
            end

            local opts = {}

            if config.plugins.nix and type(config.plugins.nix) == 'table' then
                opts = vim.tbl_extend('force', opts, config.plugins.nix)
            end
        end
    }
end

