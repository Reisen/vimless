return function(use)
    use { 'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup {
                numhl                   = true,
                current_line_blame      = false,
                current_line_blame_opts = {
                    delay         = 100,
                    virt_text_pos = 'right_align',
                },

                signs = {
                    add          = { text = '⋅' },
                    change       = { text = '~' },
                    delete       = { text = '-', show_count = true },
                    topdelete    = { text = '^', show_count = true },
                    changedelete = { text = '±', show_count = true },
                },

                count_chars = {
                    [1]   = '₁',
                    [2]   = '₂',
                    [3]   = '₃',
                    [4]   = '₄',
                    [5]   = '₅',
                    [6]   = '₆',
                    [7]   = '₇',
                    [8]   = '₈',
                    [9]   = '₉',
                    ['+'] = '.',
                }
            }

            -- Automatically add wider sign columns in files that require many.
            vim.cmd [[
                augroup sign-column-fix
                  autocmd!
                  autocmd BufEnter *.vim  setlocal signcolumn=yes:4
                  autocmd BufEnter *.rs   setlocal signcolumn=yes:4
                  autocmd BufEnter *.js   setlocal signcolumn=yes:4
                  autocmd BufEnter *.ts   setlocal signcolumn=yes:4
                  autocmd BufEnter *.hs   setlocal signcolumn=yes:4
                  autocmd BufEnter *.sh   setlocal signcolumn=yes:4
                  autocmd BufEnter *.lua  setlocal signcolumn=yes:4
                  autocmd BufEnter *.c    setlocal signcolumn=yes:4
                  autocmd BufEnter *.h    setlocal signcolumn=yes:4
                  autocmd BufEnter *.cpp  setlocal signcolumn=yes:4
                  autocmd BufEnter *.hpp  setlocal signcolumn=yes:4
                  autocmd BufEnter *.html setlocal signcolumn=yes:4
                augroup END
            ]]
        end
    }
end
