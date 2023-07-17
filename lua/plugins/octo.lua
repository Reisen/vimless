return function(config)
    if type(config.plugins.octo) == 'boolean' and not config.plugins.octo then
        return {}
    end

    return {
        'pwntester/octo.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
            'nvim-tree/nvim-web-devicons',
        },
        config = function()
            if config.plugins.octo and type(config.plugins.octo) == 'function' then
                config.plugins.octo()
                return
            end

            local opts = {}

            if config.plugins.octo and type(config.plugins.octo) == 'table' then
                opts = vim.tbl_extend('force', opts, config.plugins.octo)
            end

            require 'octo'.setup(opts)

            local octo   = require 'telescope'.extensions.octo
            local keymap = require 'keymap'

            _G.HydraMappings['Root']['Plugins'].o = { 'Octo', function() keymap:runHydra('Octo') end, { exit = true } }
            _G.HydraMappings['Octo']['Github'].g  = { 'Gists',  function() octo.gists(ivy) end,  { exit = true } }
            _G.HydraMappings['Octo']['Github'].i  = { 'Issues', function() octo.issues(ivy) end, { exit = true } }
            _G.HydraMappings['Octo']['Github'].p  = { 'PRs',    function() octo.prs(ivy) end,    { exit = true } }
            _G.HydraMappings['Octo']['Github'].r  = { 'Repos',  function() octo.repos(ivy) end,  { exit = true } }
            _G.HydraMappings['Octo']['Github'].s  = { 'Search', function() octo.search(ivy) end, { exit = true } }
        end
    }
end
