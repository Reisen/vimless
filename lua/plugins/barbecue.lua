return function(use)
    use { 'utilyre/barbecue.nvim',
        tag      = '*',
        after    = 'nvim-web-devicons',
        config   = function()
            require('barbecue').setup()
        end,
        requires = {
            'SmiteshP/nvim-navic',
            'nvim-tree/nvim-web-devicons',
        },
    }
end
