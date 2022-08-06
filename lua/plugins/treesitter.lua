return function(use)
    use { 'nvim-treesitter/nvim-treesitter',
        run    = ':TSUpdate',
        config = function()
            require 'nvim-treesitter.configs'.setup {
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
            }
        end
    }

    use { 'mfussenegger/nvim-treehopper',
        config = function()
            vim.cmd [[
                omap     <silent> m :<C-U>lua require('tsht').nodes()<CR>
                xnoremap <silent> m :lua require('tsht').nodes()<CR>
            ]]
        end
    }

    use { 'nvim-treesitter/nvim-treesitter-textobjects',
        config = function()
        end
    }

    use { 'RRethy/nvim-treesitter-textsubjects',
        config = function()
        end
    }
end
