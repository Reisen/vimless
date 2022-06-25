return function(use)
    use { 'ggandor/leap.nvim',
        config = function()
            require('leap').set_default_keymaps()
        end
    }
end
