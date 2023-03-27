return function(use, theme)
    vim.g.dracula_show_end_of_buffer = true

    -- Lush is used in other themes, so comes first.
    use 'rktjmp/lush.nvim'
    use 'nyoom-engineering/oxocarbon.nvim'
    use 'Mofiqul/dracula.nvim'
    use 'mcchrish/zenbones.nvim'
    use 'preservim/vim-colors-pencil'
    use { 'folke/tokyonight.nvim',
        config = function()
            require 'tokyonight'.setup {
                transparent    = false,
                day_brightness = 0.4,
                dim_inactive   = true,
            }

            vim.cmd ([[
                " Override the Background to be completely transparent.
                " au ColorScheme * hi Normal ctermbg=none guibg=none
                set termguicolors
                set background=dark
                colorscheme tokyonight
            ]])
        end
    }
end

