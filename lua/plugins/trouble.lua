return function(use)
    use { 'folke/trouble.nvim',
        config = function()
            require 'trouble'.setup {
                auto_open    = false,
                auto_close   = false,
                auto_preview = true,
                auto_fold    = true,
                position     = 'bottom',
                signs        = {
                    error       = "E",
                    warning     = "W",
                    hint        = "H",
                    information = "I",
                    other       = "O"
                },
            }
        end
    }
end
