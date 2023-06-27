return function(config)
    if type(config.plugins.oil) == 'boolean' and not config.plugins.oil then
        return {}
    end

    return {
        'stevearc/oil.nvim',
        config = function()
            if config.plugins.oil and type(config.plugins.oil) == 'function' then
                config.plugins.oil()
                return
            end

            local opts = {
                columns = {
                    'icon',
                    'permissions',
                    'size',
                    'mtime',
                },
                win_options = {
                    signcolumn = "yes",
                },
                float = {
                    border      = 'single',
                    padding     = 1,
                    win_options = {
                        winblend = 0
                    },
                },
                progress = {
                    border      = 'single',
                    padding     = 1,
                    win_options = {
                        winblend = 0
                    },
                },
            }

            if config.plugins.oil and type(config.plugins.oil) == 'table' then
                opts = vim.tbl_extend('force', opts, config.plugins.oil)
            end

            require('oil').setup(opts)

            vim.keymap.set("n", "-", require("oil").open, { desc = "Open Parent Directory" })
        end
    }
end

