return function(use)
    use { 'akinsho/toggleterm.nvim',
        config = function()
            require("toggleterm").setup {
                size         = 40,
                open_mapping = [[<c-\>]],
                shell        = 'fish',
                direction    = 'float',
                float_opts   = {
                    width    = vim.o.columns,
                    height   = vim.o.lines - 1,
                    border   = 'none',
                    winblend = 0,
                }
            }

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

            vim.cmd [[
                autocmd! TermOpen term://* lua set_terminal_keymaps()
            ]]
        end
    }
end
