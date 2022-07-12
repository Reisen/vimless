return function(use)
    use { 'catppuccin/nvim',
        as     = 'catppuccin',
        config = function()
            require 'catppuccin'.setup {}

            vim.g.catppuccin_flavour = "mocha"
            vim.cmd [[colorscheme catppuccin]]
        end
    }
end
