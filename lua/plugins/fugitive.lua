return function(config)
    if type(config.plugins.fugitive) == 'boolean' and not config.plugins.fugitive then
        return {}
    end

    return {
        'tpope/vim-fugitive',
        config = function()
            if config.plugins.fugitive and type(config.plugins.fugitive) == 'function' then
                config.plugins.fugitive()
                return
            end

            local keymap = require('keymap')
            _G.HydraMappings.Root.Plugins.g    = { 'Git',        function() keymap:runHydra('Git') end,      { exit = true } }
            _G.HydraMappings.Git.Fugitive.l    = { 'Log',        function() vim.cmd 'G log --oneline' end,   { exit = true } }
            _G.HydraMappings.Git.Fugitive["."] = { 'Log (File)', function() vim.cmd 'G log --oneline %' end, { exit = true } }
            _G.HydraMappings.Git.Fugitive["?"] = { 'Status',     function() vim.cmd 'Gedit:' end,            { exit = true } }
        end
    }
end

