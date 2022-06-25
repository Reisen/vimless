return function(use)
    use { 'akinsho/bufferline.nvim',
        tag      = "v2.*",
        requires = 'kyazdani42/nvim-web-devicons',
        config   = function()
            require 'bufferline'.setup {
                options = {
                    always_show_bufferline = true,
                    diagnostics            = 'nvim_lsp',
                    separator_style        = 'thick',
                    show_buffer_close_icon = false,
                    show_close_icon        = false,
                }
            }
        end
    }
end
