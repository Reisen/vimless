return function(use)
    use { 'phaazon/mind.nvim',
        branch   = 'v2.2',
        requires = { 'nvim-lua/plenary.nvim' },
        config   = function()
            require 'mind'.setup()
        end
    }
end
