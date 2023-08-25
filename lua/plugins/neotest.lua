return function(config)
    if type(config.plugins.neotest) == 'boolean' and not config.plugins.neotest then
        return {}
    end

    return {
        'nvim-neotest/neotest',
        dependencies = {
            'rouge8/neotest-rust',
            'nvim-lua/plenary.nvim',
            'nvim-treesitter/nvim-treesitter',
            'antoinemadec/FixCursorHold.nvim'
        },
        config = function()
            if config.plugins.neotest and type(config.plugins.neotest) == 'function' then
                config.plugins.neotest()
                return
            end

            local opts = {
                adapters = {
                    require('neotest-rust')
                }
            }

            if config.plugins.neotest and type(config.plugins.neotest) == 'table' then
                opts = vim.tbl_deep_extend('force', opts, config.plugins.neotest)
            end

            local neotest = require 'neotest'
            neotest.setup(opts)

            local keymap = require 'keymap'
            _G.HydraMappings["Root"]["Plugins"].n       = { 'Neotest', function() keymap:runHydra('Neotest') end,                 { exit = true } }
            _G.HydraMappings["Neotest"]["Neotest"]["."] = { 'Run Current Test', neotest.run.run,                                  { exit = true } }
            _G.HydraMappings["Neotest"]["Neotest"].a    = { 'Attach to Running Test ', neotest.run.attach,                        { exit = true } }
            _G.HydraMappings["Neotest"]["Neotest"].f    = { 'Run File Tests', function() neotest.run.run(vim.fn.expand('%')) end, { exit = true } }
            _G.HydraMappings["Neotest"]["Neotest"].s    = { 'Stop Running Tests', neotest.run.stop,                               { exit = true } }

            _G.HydraMappings["Neotest"]["UI"].l = { 'Toggle Test List', neotest.summary.toggle,      { exit = true }}
            _G.HydraMappings["Neotest"]["UI"].p = { 'Toggle Panel',     neotest.output_panel.toggle, { exit = true }}
        end
    }
end
