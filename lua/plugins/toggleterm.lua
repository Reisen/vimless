return function(use)
    use { 'akinsho/toggleterm.nvim',
        config = function()
            require("toggleterm").setup {
                size         = 15,
                open_mapping = [[<c-\>]],
                direction    = 'float',
                shell        = 'fish',
                float_opts   = {
                    width    = vim.o.columns,
                    height   = 30,
                    row      = 2,
                    border   = 'none',
                    winblend = 0,
                }
            }

            function _G.set_terminal_keymaps()
                local opts = { noremap = true }
                vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
            end

            vim.cmd [[
                autocmd! TermOpen term://* lua set_terminal_keymaps()
            ]]
        end
    }
end
