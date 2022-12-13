return function(use)
    use { 'folke/which-key.nvim',
        config = function()
            local which_key = require('which-key')

            -- Register Custom Keymapping.
            which_key.register({
                e = {
                    e = { ':1TermExec   direction=horizontal size=25 go_back=0 cmd="alot"<CR>', 'Email' },
                    h = { ':1TermExec   direction=horizontal size=25 go_back=0 cmd="dijo"<CR>', 'Dijo' },
                    j = { ':1ToggleTerm direction=horizontal size=25<CR>',                      'Open Bottom Terminal' },
                },
            }, { prefix = '<Leader>' })

            -- Configure Whichkey Design.
            which_key.setup {
                window = {
                    position = 'top',
                },

                layout = {
                    align   = "center",
                    height  = { min = 40, max = 40 },
                    spacing = 8,
                    width   = { min = 30, max = 40 },
                },
            }
        end
    }
end
