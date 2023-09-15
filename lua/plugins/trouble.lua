return function(config)
    if type(config.plugins.trouble) == 'boolean' and not config.plugins.trouble then
        return {}
    end

    return {
        'folke/trouble.nvim',
        config = function()
            if config.plugins.trouble and type(config.plugins.trouble) == 'function' then
                config.plugins.trouble()
                return
            end

            local opts = {
                auto_open    = false,
                auto_close   = false,
                auto_preview = true,
                auto_fold    = true,
                position     = 'bottom',
                signs        = {
                    error       = "●",
                    warning     = "●",
                    hint        = "●",
                    information = "●",
                    other       = "●"
                },
            }

            if config.plugins.trouble and type(config.plugins.trouble) == 'table' then
                opts = vim.tbl_deep_extend('force', opts, config.plugins.trouble)
            end

            require 'trouble'.setup(opts)

            local keymap = require 'keymap'
            local c      = require 'hydra.keymap-util'

            _G.HydraMappings.Root.Other.u = { 'Toggle UI',      function() keymap:runHydra('UI') end, { exit = true } }
            _G.HydraMappings.UI.UI.t      = { 'Toggle Trouble', c.cmd('TroubleToggle'),               { exit = true } }
            _G.HydraMappings.UI.UI.n      = { 'Toggle Neotree', c.cmd('Neotree show'),                { exit = true } }
        end
    }
end
