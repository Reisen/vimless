return function(config)
    if type(config.plugins.haskell) == 'boolean' and not config.plugins.haskell then
        return {}
    end

    return {
        'mrcjkb/haskell-tools.nvim',
        branch       = '2.x.x',
        dependencies = {
            'nvim-lua/plenary.nvim' ,
            'nvim-telescope/telescope.nvim',
        },
        config   = function()
            if config.plugins.haskell and type(config.plugins.haskell) == 'function' then
                config.plugins.haskell()
                return
            end

            -- local opts = {}

            local keymap = require 'keymap'
            keymap:registerLanguage('Haskell', 'haskell')
            _G.HydraMappings['Haskell']['Haskell'].k = { 'Move Item Up', function() end, { exit = true }}
        end
    }
end
