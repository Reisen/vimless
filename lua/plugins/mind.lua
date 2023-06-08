return function(config)
    return {
        'phaazon/mind.nvim',
        branch       = 'v2.2',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config       = function()
            require 'mind'.setup()
        end
    }
end
