-- Toggleterm provides floating terminals that can be toggled on and off. The
-- default vimless configuration for this is a full screen floating terminal
-- that can be opened/close with Ctrl+\

return function(config)
    if type(config.plugins.toggleterm) == 'boolean' and not config.plugins.toggleterm then
        return {}
    end

    return {
        'akinsho/toggleterm.nvim',
        config = function()
            -- Use config toggleterm handler if it exists.
            if config.plugins.toggleterm and type(config.plugins.toggleterm) == 'function' then
                config.plugins.toggleterm()
            else
                local opts = {
                    size         = 40,
                    open_mapping = "<c-\\>",
                    shell        = 'bash',
                    direction    = 'float',
                    float_opts   = {
                        width    = vim.o.columns,
                        height   = vim.o.lines - 1,
                        border   = 'none',
                        winblend = 0,
                    }
                }

                -- Merge user settings with defaults if they've been specified.
                if config.plugins.toggleterm and type(config.plugins.toggleterm) == 'table' then
                    opts = vim.tbl_extend('force', opts, config.plugins.toggleterm)
                end

                require("toggleterm").setup(opts)
            end

            -- Bind <esc> to switch to normal mode while in a terminal.
            function _G.set_terminal_keymaps()
                vim.api.nvim_buf_set_keymap(
                    0,
                    't',
                    '<esc>',
                    [[<C-\><C-n>]],
                    { noremap = true }
                )
            end

            -- vim.cmd [[
            --     autocmd! TermOpen term://* lua set_terminal_keymaps()
            -- ]]
        end
    }
end
