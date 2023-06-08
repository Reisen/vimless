return function(config)
    if type(config.plugins.nvimtree) == 'boolean' and not config.plugins.nvimtree then
        return {}
    end

    return {
        "nvim-tree/nvim-tree.lua",
        dependencies = {"nvim-tree/nvim-web-devicons"},
        config       = function()
            if config.plugins.nvimtree and type(config.plugins.nvimtree) == 'function' then
                config.plugins.nvimtree()
                return
            end

            local opts = {
                hijack_netrw  = true,
                disable_netrw = false,
                renderer = {
                    icons = {
                        glyphs = require('circles').get_nvimtree_glyphs(),
                    },
                },
            }

            if config.plugins.nvimtree and type(config.plugins.nvimtree) == 'table' then
                opts = vim.tbl_extend('force', opts, config.plugins.nvimtree)
            end

            require "nvim-tree".setup(opts)
        end
    }
end
