return function(config)
    if type(config.plugins.treesitter) == 'boolean' and not config.plugins.treesitter then
        return {}
    end

    return {
        'nvim-treesitter/nvim-treesitter',
        build        = ':TSUpdate',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
            'RRethy/nvim-treesitter-textsubjects',
            'mfussenegger/nvim-treehopper'
        },
        config = function()
            if config.plugins.treesitter and type(config.plugins.treesitter) == 'function' then
                config.plugins.treesitter()
                return
            end

            local opts = {
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection    = "gnn",
                        node_incremental  = ".",
                        scope_incremental = ";",
                        node_decremental  = ",",
                    },
                },

                textsubjects = {
                    enable         = true,
                    prev_selection = ',',
                    keymaps        = {
                        ['.']  = 'textsubjects-smart',
                        [';']  = 'textsubjects-container-outer',
                        ['i;'] = 'textsubjects-container-inner',
                    },
                },

                vim.cmd [[
                    omap     <silent> m :<C-U>lua require('tsht').nodes()<CR>
                    xnoremap <silent> m :lua require('tsht').nodes()<CR>
                ]]
            }

            if config.plugins.treesitter and type(config.plugins.treesitter) == 'table' then
                opts = vim.tbl_extend('force', opts, config.plugins.treesitter)
            end

            require 'nvim-treesitter.configs'.setup(opts)
        end
    }
end
