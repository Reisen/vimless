return function(config)
    if type(config.plugins.zen) == 'boolean' and not config.plugins.zen then
        return {}
    end

    return {
        'folke/zen-mode.nvim',
        config = function()
            if config.plugins.zen and type(config.plugins.zen) == 'function' then
                config.plugins.zen()
                return
            end

            local opts = {
                window = {
                    backdrop = 1,
                    width    = 0.7,
                    height   = 0.9,
                },
                plugins = {
                    gitsigns = { enabled = false },
                    twilight = { enabled = false },
                },
            }

            if config.plugins.zen and type(config.plugins.zen) == 'table' then
                opts = vim.tbl_extend('force', opts, config.plugins.zen)
            end

            require 'zen-mode'.setup(opts)

            -- Bind :ZenMode to <leader>z
            vim.api.nvim_set_keymap('n', '<leader>z', '<cmd>ZenMode<CR>', {
                noremap = true,
                silent  = true,
            })
        end
    }
end

