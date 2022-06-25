return function(use)
    use { 'lukas-reineke/indent-blankline.nvim',
        config = function()
            vim.cmd [[
                highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine
                highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine
                highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine
                highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine
                highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine
                highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine
            ]]

            vim.opt.list = true

            require('indent_blankline').setup {
                space_char_blankline       = ' ',
                show_current_context       = true,
                char_highlight_list        = {} or {
                    'IndentBlanklineIndent1',
                    'IndentBlanklineIndent2',
                    'IndentBlanklineIndent3',
                    'IndentBlanklineIndent4',
                    'IndentBlanklineIndent5',
                    'IndentBlanklineIndent6',
                },
            }
        end
    }
end
