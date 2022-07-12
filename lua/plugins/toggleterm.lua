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
