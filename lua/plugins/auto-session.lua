return function(use)
    use { 'rmagatti/auto-session',
        config = function()
            require('auto-session').setup {
                log_level                  = 'info',
                auto_session_suppress_dirs = { '~/', '~/Projects' }
            }
        end
    }

    use {
        'rmagatti/session-lens',
        requires = {
            'rmagatti/auto-session',
            'nvim-telescope/telescope.nvim',
        },
        config = function()
            require('session-lens').setup {
                previewer = false,
                winblend  = 0,
            }
        end
    }
end
