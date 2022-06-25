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
                    entry_prefix     = "  ",
                    prompt_prefix    = "  ",
                    selection_caret  = "  ",
                    color_devicons   = true,
                    path_display     = { "smart" },
                    sorting_strategy = "ascending",
                    layout_strategy  = "horizontal",
                    layout_config    = {
                        width          = 0.87,
                        height         = 0.80,
                        preview_cutoff = 50,
                        horizontal = {
                            prompt_position = "top",
                            preview_width   = 0.55,
                            results_width   = 0.8,
                        },
                        vertical = {
                            mirror = false,
                        },
                    },
                }
            }

            require 'telescope'.load_extension('fzf')
        end
    }
end
