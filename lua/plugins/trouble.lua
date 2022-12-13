return function(use)
    use { 'folke/trouble.nvim',
        config = function()
            require 'trouble'.setup {
                auto_open    = false,
                auto_close   = false,
                auto_preview = true,
                auto_fold    = true,
                position     = 'left',
                signs        = {
                    error       = "",
                    warning     = "",
                    hint        = "",
                    information = "",
                    other       = "﫠"
                },
            }
        end
    }
end
