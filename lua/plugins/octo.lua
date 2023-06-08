return function(config)
    if type(config.plugins.octo) == 'boolean' and not config.plugins.octo then
        return {}
    end

    return {
        'pwntester/octo.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
            'nvim-tree/nvim-web-devicons',
        },
        config = function()
            if config.plugins.octo and type(config.plugins.octo) == 'function' then
                config.plugins.octo()
                return
            end

            local opts = {}

            if config.plugins.octo and type(config.plugins.octo) == 'table' then
                opts = vim.tbl_extend('force', opts, config.plugins.octo)
            end

            require 'octo'.setup(opts)
        end
    }
end
