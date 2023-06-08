return function(config)
    if type(config.plugins.telescope) == 'boolean' and not config.plugins.telescope then
        return {}
    end

    -- Configure Telescope itself,
    return {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-ui-select.nvim',
            'nvim-telescope/telescope-file-browser.nvim',
            'nvim-telescope/telescope-github.nvim',
            'nvim-telescope/telescope-project.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        },
        config = function()
            if config.plugins.telescope and type(config.plugins.telescope) == 'function' then
                config.plugins.telescope()
                return
            end

            local opts = {
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
                    borderchars      = {
                        '─', '│', '─', '│', '┌', '┐', '┘', '└',
                    },

                    mappings         = {
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

            if config.plugins.telescope and type(config.plugins.telescope) == 'table' then
                opts = vim.tbl_extend('force', opts, config.plugins.telescope)
            end

            require 'telescope'.setup(opts)
            require 'telescope'.load_extension('fzf')
            require 'telescope'.load_extension('file_browser')
            require 'telescope'.load_extension('ui-select')
            require 'telescope'.load_extension('gh')
            require 'telescope'.load_extension('project')
            require 'plugins/tusk'

            -- vim.api.nvim_set_keymap(
            --     "n",
            --     "<leader>x",
            --     "<cmd>lua require('onyx.telescope').telescope_commandline()<cr>",
            --     { noremap = true, silent = true }
            -- )
        end
    }
end
