return function(use, theme)
    vim.g.dracula_show_end_of_buffer = true

    -- Lush is used in other themes, so comes first.
    use 'rktjmp/lush.nvim'
    use 'nyoom-engineering/oxocarbon.nvim'
    use 'Mofiqul/dracula.nvim'
    use 'mcchrish/zenbones.nvim'
    use 'preservim/vim-colors-pencil'
    -- use { 'chriskempson/base16-vim',
    --     config = function()
    --         vim.cmd [[
    --             let base16colorspace=256
    --             colorscheme base16-default-dark
    --
    --             " Make some adjustments to highlight groups that don't look great without 256 colors.
    --             highlight  link           HydraHint     Normal
    --             highlight  link           HydraBorder   Normal
    --             highlight  HydraRed       ctermfg=1     
    --             highlight  HydraBlue      ctermfg=4     
    --             highlight  HydraAmaranth  ctermfg=5     
    --             highlight  HydraTeal      ctermfg=6     
    --             highlight  HydraPink      ctermfg=13    
    --             highlight  LineNr         ctermbg=NONE  guibg=NONE
    --             highlight  SignColumn     ctermbg=NONE  guibg=NONE
    --         ]]
    --     end
    -- }

    -- use { 'folke/tokyonight.nvim',
    --     config = function()
    --         require 'tokyonight'.setup {
    --             transparent    = false,
    --             day_brightness = 0.4,
    --             dim_inactive   = true,
    --         }
    --
    --         vim.cmd [[
    --             " Set Themes, assume dark background.
    --             set termguicolors
    --             set background=dark
    --
    --             " Set Tokyonight as the colour scheme. Disable for now due to
    --             " defaulting to catppuccin which has a similar colour scheme
    --             " when using macchiato.
    --             "colorscheme catppuccin-macchiato
    --         ]]
    --     end
    -- }

    use { 'catppuccin/nvim',
        as     = 'catppuccin',
        config = function()
            require 'catppuccin'.setup {
                flavor       = 'macchiato',
                dim_inactive = {
                    enable     = true,
                    shade      = 'dark',
                    percentage = 0.5,
                },
            }

            vim.g.catppuccin_flavor = "macchiato"

            vim.cmd [[
                colorscheme catppuccin-macchiato

                " Set HydraHint highlight to normal background.
                highlight link HydraHint Normal
            ]]
        end
    }
end

