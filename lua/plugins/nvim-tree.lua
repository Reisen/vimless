return function(use)
    use {
        "nvim-tree/nvim-tree.lua",
        requires = {"nvim-tree/nvim-web-devicons"},
        config   = function()
            require("nvim-tree").setup {
                hijack_netrw  = true,
                disable_netrw = false,
                renderer = {
                    icons = {
                        glyphs = require('circles').get_nvimtree_glyphs(),
                    },
                },
            }
        end
    }
end
