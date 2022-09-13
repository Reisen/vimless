return function(use)
    -- FZF Sorted for fast filtering.
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

    -- Configure Telescope itself,
    use { 'nvim-telescope/telescope.nvim',
        requires = 'nvim-lua/plenary.nvim',
        config   = function()
            require 'telescope'.setup {
                extensions = {
                    fzf = {
                        fuzzy                   = true,
                        override_generic_sorter = true,
                        override_file_sorter    = true,
                        case_mode               = 'smart_case',
                    },
                },
                defaults = {
                    borderchars = {
                        '─',
                        '│',
                        '─',
                        '│',
                        '┌',
                        '┐',
                        '┘',
                        '└',
                    },
                    color_devicons   = true,
                    path_display     = { 'smart' },
                    sorting_strategy = 'ascending',
                    layout_strategy  = 'horizontal',

                    preview = {
                        hide_on_startup = true
                    },

                    layout_config = {
                        preview_cutoff = 50,
                        horizontal     = { prompt_position = 'bottom', },
                        vertical       = { mirror = false, },
                    },
                }
            }

            require 'telescope'.load_extension('fzf')
        end
    }
end
