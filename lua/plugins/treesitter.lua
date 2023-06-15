return function(config)
    if type(config.plugins.treesitter) == 'boolean' and not config.plugins.treesitter then
        return {}
    end

    return {
        'nvim-treesitter/nvim-treesitter',
        build        = ':TSUpdate',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        config = function()
            if config.plugins.treesitter and type(config.plugins.treesitter) == 'function' then
                config.plugins.treesitter()
                return
            end

            local opts = {
                highlight = {
                    enable = true,
                },

                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection    = "gnn",
                        node_incremental  = ".",
                        scope_incremental = ";",
                        node_decremental  = ",",
                    },
                },
            }

            if config.plugins.treesitter and type(config.plugins.treesitter) == 'table' then
                opts = vim.tbl_extend('force', opts, config.plugins.treesitter)
            end

            require 'nvim-treesitter.configs'.setup(opts)
        end
    }
end
