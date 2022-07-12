return function(use)
    use { 'nvim-treesitter/nvim-treesitter',
        run    = ':TSUpdate',
        config = function()
            -- require 'nvim-treesitter.configs'.setup {
            --     textobjects = {
            --         select = {
            --             enable    = true,
            --             lookahead = true,
            --             keymaps   = {
            --                 ["af"] = "@function.outer",
            --                 ["if"] = "@function.inner",
            --                 ["ac"] = "@class.outer",
            --                 ["ic"] = "@class.inner",
            --                 ["ab"] = "@block.outer",
            --                 ["ib"] = "@block.inner",
            --             },
            --         },
            --     },
            -- }

            require 'nvim-treesitter.configs'.setup {
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

    use 'nvim-treesitter/playground'

    use { 'nvim-treesitter/nvim-treesitter-textobjects',
        config = function()
        end
    }

    use { 'RRethy/nvim-treesitter-textsubjects',
        config = function()
        end
    }
end
