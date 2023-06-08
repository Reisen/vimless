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
                    position = 'top',
                },

                layout = {
                    align   = "center",
                    height  = { min = 40, max = 40 },
                    spacing = 8,
                    width   = { min = 30, max = 40 },
                },
            }

            if config.plugins.which_key and type(config.plugins.which_key) == 'table' then
                opts = vim.tbl_extend('force', opts, config.plugins.which_key)
            end

            -- Register Custom Keymapping.
            require 'which-key'.register({
                e = {
                    e = { ':1TermExec   direction=horizontal size=25 go_back=0 cmd="alot"<CR>', 'Email' },
                    h = { ':1TermExec   direction=horizontal size=25 go_back=0 cmd="dijo"<CR>', 'Dijo' },
                    j = { ':1ToggleTerm direction=horizontal size=25<CR>',                      'Open Bottom Terminal' },
                },
            }, { prefix = '<Leader>' })

            -- Configure Whichkey Design.
            require 'which-key'.setup(opts)
        end
    }
end
