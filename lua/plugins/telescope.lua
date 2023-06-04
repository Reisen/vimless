return function(use)
    -- FZF Sorted for fast filtering.
    use { 'nvim-telescope/telescope-fzf-native.nvim',
        run = 'make'
    }

    -- Configure Telescope itself,
    use { 'nvim-telescope/telescope.nvim',
        requires = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-ui-select.nvim',
            'nvim-telescope/telescope-file-browser.nvim',
            'nvim-telescope/telescope-github.nvim',
            'nvim-telescope/telescope-project.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
        },
        config = function()
            require 'telescope'.setup {
                extensions = {
                    fzf = {
                        fuzzy                   = true,
                        override_generic_sorter = true,
                        override_file_sorter    = true,
                        case_mode               = 'smart_case',
                    },

                    ['ui-select'] = {
                        require 'telescope.themes'.get_dropdown {
                            border        = true,
                            layout_config = { height = 10 },
                            borderchars   = {
                                prompt  = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
                                results = { ' ', '│', '─', '│', '│', '│', '┘', '└' },
                                preview = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
                            },
                        },
                    },
                },

                defaults = {
                    borderchars = {
                        '─', '│', '─', '│', '┌', '┐', '┘', '└',
                    },

                    mappings = {
                        i = {
                            ["<esc>"] = require 'telescope.actions'.close,
                        },
                    },

                    color_devicons   = true,
                    path_display     = { 'absolute' },
                    sorting_strategy = 'ascending',
                    preview          = {
                        hide_on_startup = true
                    },
                }
            }

            require 'telescope'.load_extension('fzf')
            require 'telescope'.load_extension('file_browser')
            require 'telescope'.load_extension('ui-select')
            require 'telescope'.load_extension('gh')
            require 'telescope'.load_extension('project')
        end
    }
end
