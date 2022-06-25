return function(use)
    use { 'navarasu/onedark.nvim',
        config = function()
            require 'onedark'.setup {
                style         = 'deep',
                term_colors   = true,
                ending_tildes = false,
                diagnostics   = {
                    darker     = true,
                    undercurl  = true,
                    background = true,
                },
            }

            -- Enable theme and customize colours for other views.
            vim.cmd [[
                augroup quick_scope
                autocmd!
                autocmd ColorScheme * hi QuickScopePrimary   guifg='#FF0000' gui=bold
                autocmd ColorScheme * hi QuickScopeSecondary guifg='#FF7799' gui=bold
                augroup END
            ]]

            require 'onedark'.load()
        end

    }
end
