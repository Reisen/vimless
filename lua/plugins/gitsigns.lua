return function(use)
    use { 'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup {
                current_line_blame      = false,
                current_line_blame_opts = {
                    virt_text_pos = 'right_align',
                },

                signs = {
                    add          = { text = '+' },
                    change       = { text = '~' },
                    delete       = { text = '_' },
                    topdelete    = { text = '‾' },
                    changedelete = { text = '~' },
                }
            }

            -- Automatically add wider sign columns in
            -- files that require many.
            vim.cmd [[
                augroup sign-column-fix
                  autocmd!
                  autocmd BufEnter *.rs  setlocal signcolumn=yes:4
                  autocmd BufEnter *.js  setlocal signcolumn=yes:4
                  autocmd BufEnter *.ts  setlocal signcolumn=yes:4
                  autocmd BufEnter *.hs  setlocal signcolumn=yes:4
                  autocmd BufEnter *.sh  setlocal signcolumn=yes:4
                  autocmd BufEnter *.lua setlocal signcolumn=yes:4
                  autocmd BufEnter *.c   setlocal signcolumn=yes:4
                  autocmd BufEnter *.h   setlocal signcolumn=yes:4
                  autocmd BufEnter *.cpp setlocal signcolumn=yes:4
                  autocmd BufEnter *.hpp setlocal signcolumn=yes:4
                augroup END
            ]]
        end
    }
end
