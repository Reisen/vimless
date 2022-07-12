return function(use)
    use { 'lukas-reineke/indent-blankline.nvim',
        config = function()
            vim.opt.list = true
            vim.cmd [[highlight IndentBlanklineIndent1 guifg=#333435 gui=nocombine]]
            vim.cmd [[highlight IndentBlanklineIndent2 guifg=#333435 gui=nocombine]]

            require('indent_blankline').setup {
                space_char_blankline           = ' ',
                show_current_context           = true,
                show_current_context_start     = false,
                show_trailing_blankline_indent = false,
                char_highlight_list            = {
                    "IndentBlanklineIndent1",
                    "IndentBlanklineIndent2",
                },
                space_char_highlight_list      = {
                    "IndentBlanklineIndent1",
                    "IndentBlanklineIndent2",
                },
            }
        end
    }
end
