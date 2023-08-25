return function(config)
    if type(config.plugins.nvim_web_devicons) == 'boolean' and not config.plugins.nvim_web_devicons then
        return {}
    end

    return {
        'nvim-tree/nvim-web-devicons',
        config = function()
            if config.plugins.nvim_web_devicons and type(config.plugins.nvim_web_devicons) == 'function' then
                config.plugins.nvim_web_devicons()
                return
            end

            local opts = {
                default = true;
            }

            if config.plugins.nvim_web_devicons and type(config.plugins.nvim_web_devicons) == 'table' then
                opts = vim.tbl_deep_extend('force', opts, config.plugins.nvim_web_devicons)
            end

            require 'nvim-web-devicons'.setup(opts)
        end
    }
end
