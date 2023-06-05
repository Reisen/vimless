return function(use, theme)
    vim.g.dracula_show_end_of_buffer = true

    -- Lush is used in other themes, so comes first.
    use 'rktjmp/lush.nvim'
    use 'nyoom-engineering/oxocarbon.nvim'
    use 'Mofiqul/dracula.nvim'
    use 'mcchrish/zenbones.nvim'
    use 'preservim/vim-colors-pencil'
    use { 'chriskempson/base16-vim',
        config = function()
            vim.cmd [[
                let base16colorspace=256
                colorscheme base16-default-dark

                " Make some adjustments to highlight groups that don't look great without 256 colors.
                highlight  HydraHint      ctermbg=18    guibg=NONE  ctermfg=NONE  guifg=NONE
                highlight  link           HydraBorder   Normal                    
                highlight  HydraRed       ctermfg=1                               
                highlight  HydraBlue      ctermfg=4                               
                highlight  HydraAmaranth  ctermfg=5                               
                highlight  HydraTeal      ctermfg=6                               
                highlight  HydraPink      ctermfg=13                              
                highlight  LineNr         ctermbg=NONE  guibg=NONE                
                highlight  SignColumn     ctermbg=NONE  guibg=NONE                

                " Hide distracting UI elements like separators, vertical splits, and ~ lines.
                highlight  EndOfBuffer ctermfg=bg       guifg=bg

                " Override the DiffAdd/DiffDelete/DiffChange highlight groups
                " to use the existing highlighting just with a darkened
                " background. We want to prevent fg overriding.
                highlight  DiffAdd     ctermbg=18  guibg=NONE  ctermfg=2   guifg=NONE
                highlight  DiffDelete  ctermbg=18  guibg=NONE  ctermfg=bg  guifg=NONE
                highlight  DiffChange  ctermbg=18  guibg=NONE  ctermfg=3   guifg=NONE

                " Keep syntax highlighting intact during gitsigns line highlighting.
                highlight  GitGutterAdd      ctermfg=2              ctermbg=NONE  guifg=NONE  guibg=NONE
                highlight  GitGutterChange   ctermfg=4              ctermbg=NONE  guifg=NONE  guibg=NONE
                highlight  GitGutterDelete   ctermfg=1              ctermbg=NONE  guifg=NONE  guibg=NONE
                highlight  GitSignsAdd       ctermfg=2              ctermbg=18    guifg=NONE  guibg=NONE
                highlight  GitSignsChange    ctermfg=4              ctermbg=18    guifg=NONE  guibg=NONE
                highlight  GitSignsDelete    ctermfg=1              ctermbg=NONE  guifg=NONE  guibg=NONE
                highlight  GitSignsAddNr     ctermfg=2              ctermbg=18    guifg=NONE  guibg=NONE
                highlight  GitSignsChangeNr  ctermfg=4              ctermbg=18    guifg=NONE  guibg=NONE
                highlight  GitSignsDeleteNr  ctermfg=1              ctermbg=NONE  guifg=NONE  guibg=NONE
                highlight  GitSignsAddLn     ctermfg=NONE           ctermbg=18    guifg=NONE  guibg=NONE
                highlight  GitSignsChangeLn  ctermfg=NONE           ctermbg=18    guifg=NONE  guibg=NONE
                highlight  link              GitSignsAddPreview     DiffAdd                   
                highlight  link              GitSignsDeletePreview  DiffDelete                

                " nvim-cmp does not highlight well with base16, so we set this up ourselves.
                highlight  CmpItemAbbr       ctermfg=7  guifg=NONE
                highlight  CmpItemAbbrMatch  ctermfg=1  guifg=NONE
                highlight  CmpItemMenu       ctermfg=1  guifg=NONE

                " Now make the highlighted entry background dark so we can tell which item we're on.
                " This is done via PMenu highlight group.
                highlight  Pmenu     ctermfg=7  guifg=NONE ctermbg=18  guibg=NONE
                highlight  PmenuSel  ctermfg=7  guifg=NONE ctermbg=19  guibg=NONE

                " Override Telescope highlights to make the viewer more aesthetic.
                highlight  TelescopeTitle   ctermfg=4  ctermbg=18  guifg=NONE  guibg=NONE
                highlight  TelescopeBorder  ctermfg=4  ctermbg=18  guifg=NONE  guibg=NONE
                highlight  TelescopeNormal  ctermfg=7  ctermbg=18  guifg=NONE  guibg=NONE

                " Set Vim Visuals, Status and Winbar highlights.
                highlight  VertSplit     ctermfg=bg  ctermbg=NONE  guifg=NONE  guibg=NONE
                highlight  StatusLine    ctermfg=7   ctermbg=NONE  guifg=NONE  guibg=NONE
                highlight  StatusLineNC  ctermfg=20  ctermbg=NONE  guifg=NONE  guibg=NONE
                highlight  WinBar        ctermfg=7   ctermbg=18    guifg=NONE  guibg=NONE
                highlight  WinBarNC      ctermfg=20  ctermbg=18    guifg=NONE  guibg=NONE

                " NeoTree highlights.
                highlight  NeoTreeIndentMarker  ctermfg=8  guifg=NONE  ctermbg=NONE  guibg=NONE
                highlight  NeoTreeVertSplit     ctermfg=1  guifg=NONE  ctermbg=1     guibg=NONE
            ]]
        end
    }

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
        end
    }
end

