return function(config)
    if type(config.plugins.which_key) == 'boolean' and not config.plugins.which_key then
        return {}
    end

    return {
        'folke/which-key.nvim',
        config = function()
            if config.plugins.which_key and type(config.plugins.which_key) == 'function' then
                config.plugins.which_key()
                return
            end

            local opts = {
                window = {
                    position = 'bottom',
                },

                layout = {
                    align   = "center",
                    spacing = 8,
                    height  = { min = 10, max = 15 },
                    width   = { min = 30, max = 40 },
                },

                triggers = {
                    '`', "'", '"', 'z=', '<space>'
                },

                triggers_nowait = {
                    '<space>',
                },
            }

            if config.plugins.which_key and type(config.plugins.which_key) == 'table' then
                opts = vim.tbl_deep_extend('force', opts, config.plugins.which_key)
            end

            -- Register Custom Keymapping.
            -- require 'which-key'.register({
            --     e = {
            --         e = { ':1TermExec   direction=horizontal size=25 go_back=0 cmd="alot"<CR>', 'Email' },
            --         h = { ':1TermExec   direction=horizontal size=25 go_back=0 cmd="dijo"<CR>', 'Dijo' },
            --         j = { ':1ToggleTerm direction=horizontal size=25<CR>',                      'Open Bottom Terminal' },
            --     },
            -- }, { prefix = '<Leader>' })

            -- Configure Whichkey Design.
            require 'which-key'.setup(opts)

            local keymap = require 'keymap'
            local c      = require 'hydra.keymap-util'

            _G.HydraMappings['Root']['Plugins'].k = { 'WhichKey', c.cmd('WhichKey'), { exit = true } }
        end
    }
end
