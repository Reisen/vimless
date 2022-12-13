return function(use)
    use { 'folke/tokyonight.nvim',
        config = function()
            vim.g.tokyonight_style                    = "day"
            vim.g.tokyonight_dark_float               = false
            vim.g.tokyonight_dark_sidebar             = true
            vim.g.tokyonight_day_brightness           = 0.8
            vim.g.tokyonight_italic_comments          = false
            vim.g.tokyonight_italic_keywords          = false
            vim.g.tokyonight_transparent              = false
            vim.g.tokyonight_hide_inactive_statusline = true
            vim.g.tokyonight_sidebars                 = { 'packer' }

            -- Import Colours for styling other views.
            local _colors = require("tokyonight.colors").setup({})

            -- Enable theme and customize colours for other views.
            vim.cmd [[
                augroup quick_scope
                autocmd!
                autocmd ColorScheme * hi QuickScopePrimary   guifg='#FF0000' gui=bold
                autocmd ColorScheme * hi QuickScopeSecondary guifg='#FF7799' gui=bold
                augroup END
            ]]
        end
    }
end
