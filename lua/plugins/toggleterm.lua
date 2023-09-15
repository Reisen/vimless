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
                    size            = 20,
                    open_mapping    = "<c-\\>",
                    shell           = 'bash',
                    shade_terminals = false,
                    direction       = 'horizontal',
                    float_opts = {
                        width    = vim.o.columns,
                        size     = vim.o.lines - 1,
                        border   = 'none',
                        winblend = 0,
                    }
                }

                -- Merge user settings with defaults if they've been specified.
                if config.plugins.toggleterm and type(config.plugins.toggleterm) == 'table' then
                    opts = vim.tbl_deep_extend('force', opts, config.plugins.toggleterm)
                end

                require("toggleterm").setup(opts)

                -- Bind double <esc> to switch to normal mode while in a terminal.
                local function set_terminal_keymaps()
                    vim.api.nvim_buf_set_keymap(0, 't', '<esc><esc>', [[<C-\><C-n>]], { noremap = true })
                end

                -- Note the above vim.cmd can be done in native Lua like so:
                local keymap_group = vim.api.nvim_create_augroup("ToggleTermKeymaps", {
                    clear = true,
                })

                vim.api.nvim_create_autocmd({'TermOpen'}, {
                    group    = keymap_group,
                    pattern  = { "term://*" },
                    callback = function()
                        set_terminal_keymaps()
                    end
                })

                _G.HydraMappings.Root.Plugins['>'] = { 'Terminal', function() vim.cmd 'ToggleTerm' end, { exit = true } }
            end
        end
    }
end
