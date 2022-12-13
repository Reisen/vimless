return function(use)
    use { 'akinsho/toggleterm.nvim',
        config = function()
            require("toggleterm").setup {
                size         = 40,
                open_mapping = [[<c-\>]],
                direction    = 'tab',
                shell        = 'fish',
                float_opts   = {} or {
                    width    = math.floor(vim.o.columns * 0.5),
                    height   = 30,
                    row      = 2,
                    border   = {
                        '','','','','','-','',''
                    }
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
