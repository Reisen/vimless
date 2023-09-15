return function(config)
    if type(config.plugins.lazygit) == 'boolean' and not config.plugins.lazygit then
        return {}
    end

    return {
        'kdheepak/lazygit.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim'
        },
        config = function()
            if config.plugins.lazygit and type(config.plugins.lazygit) == 'function' then
                config.plugins.lazygit()
                return
            end

            vim.g.lazygit_floating_window_winblend       = 0
            vim.g.lazygit_floating_window_scaling_factor = 1
            vim.g.lazygit_floating_window_border_chars   = {'','', '', '', '','', '', ''}
            vim.g.lazygit_floating_window_use_plenary    = 0
            vim.g.lazygit_use_neovim_remote              = 1
            vim.g.lazygit_use_custom_config_file_path    = 1
            -- Use the config file at the top of the neovim configuration dir.
            vim.g.lazygit_config_file_path               = vim.fn.stdpath('config') .. '/lazygit.yaml'

            local keymap = require('keymap')
            _G.HydraMappings.Root.Plugins.g   = { 'Git',     function() keymap:runHydra('Git') end, { exit = true } }
            _G.HydraMappings.Git.Lazygit['-'] = { 'LazyGit', function() vim.cmd 'LazyGit' end,      { exit = true } }
        end
    }
end

