return function(use)
    use { 'lewis6991/gitsigns.nvim',
        config = function()
            require 'gitsigns'.setup {
                numhl                   = true,
                linehl                  = false,
                signcolumn              = true,
                current_line_blame      = false,
                word_diff               = false,
                current_line_blame_opts = {
                    delay         = 100,
                    virt_text_pos = 'right_align',
                },

                signs = {
                    add          = { text = '+', show_count = false },
                    change       = { text = '~', show_count = false },
                    delete       = { text = '-', show_count = false },
                    topdelete    = { text = '_', show_count = false },
                    changedelete = { text = '-', show_count = false },
                },

                -- count_chars = {
                --     [1]   = '1',
                --     [2]   = '2',
                --     [3]   = '3',
                --     [4]   = '4',
                --     [5]   = '5',
                --     [6]   = '6',
                --     [7]   = '7',
                --     [8]   = '8',
                --     [9]   = '9',
                --     ['+'] = '+',
                -- }
            }

            -- Automatically add wider sign columns in files that require many.
            vim.cmd [[
                augroup sign-column-fix
                  autocmd!
                  "autocmd BufEnter *.vim  setlocal signcolumn=yes:4
                  "autocmd BufEnter *.rs   setlocal signcolumn=yes:4
                  "autocmd BufEnter *.js   setlocal signcolumn=yes:4
                  "autocmd BufEnter *.ts   setlocal signcolumn=yes:4
                  "autocmd BufEnter *.sh   setlocal signcolumn=yes:4
                  "autocmd BufEnter *.lua  setlocal signcolumn=yes:4
                  "autocmd BufEnter *.c    setlocal signcolumn=yes:4
                  "autocmd BufEnter *.h    setlocal signcolumn=yes:4
                  "autocmd BufEnter *.hpp  setlocal signcolumn=yes:4
                  "autocmd BufEnter *.html setlocal signcolumn=yes:4
                augroup END
            ]]
        end
    }
end
