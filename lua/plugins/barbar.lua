return function(use)
    use { 'romgrk/barbar.nvim',
        requires = 'kyazdani42/nvim-web-devicons',
        config   = function()
            require 'bufferline'.setup {
            }
        end
    }
end
