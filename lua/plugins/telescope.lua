return function(config)
    if type(config.plugins.telescope) == 'boolean' and not config.plugins.telescope then
        return {}
    end

    -- Configure Telescope itself,
    return {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'Marskey/telescope-sg',
            'camgraff/telescope-tmux.nvim',
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-file-browser.nvim',
            'nvim-telescope/telescope-github.nvim',
            'nvim-telescope/telescope-project.nvim',
            'nvim-telescope/telescope-ui-select.nvim',
            'nvim-telescope/telescope-ui-select.nvim',
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

                    tusk = require 'telescope.themes'.get_dropdown {
                        border        = true,
                        layout_config = { height = 15, width = { padding = 0 }, anchor = 'N' },
                        borderchars   = {
                            prompt  = { ' ', '', ' ', '', '', '', '', '' },
                            results = { ' ', '', '─', '', '', '', '', '' },
                            preview = { ' ', '', ' ', '', '', '', '', '' },
                        },
                    },

                    ['ui-select'] = require 'telescope.themes'.get_dropdown {
                        border        = true,
                        layout_config = { height = 15, width = { padding = 0 }, anchor = 'N' },
                        borderchars   = {
                            prompt  = { ' ', '', ' ', '', '', '', '', '' },
                            results = { ' ', '', '─', '', '', '', '', '' },
                            preview = { ' ', '', ' ', '', '', '', '', '' },
                        },
                    },

                    tmux = {
                        layout_config = require 'telescope.themes'.get_dropdown {
                            border        = true,
                            layout_config = { height = 15, width = { padding = 0 }, anchor = 'N' },
                            borderchars   = {
                                prompt  = { ' ', '', ' ', '', '', '', '', '' },
                                results = { ' ', '', '─', '', '', '', '', '' },
                                preview = { ' ', '', ' ', '', '', '', '', '' },
                            },
                        },
                    },

                    ast_grep = {
                        command         = { 'sg', '--json = stream' },
                        grep_open_files = false,
                        lang            = nil,
                    }
                },

                defaults = require 'telescope.themes'.get_dropdown {
                    border           = true,
                    color_devicons   = true,
                    layout_config = { height = 15, width = { padding = 0 }, anchor = 'N' },
                    path_display     = { 'absolute' },
                    sorting_strategy = 'ascending',
                    borderchars      = {
                        prompt  = { ' ', '', ' ', '', '', '', '', '' },
                        results = { ' ', '', '─', '', '', '', '', '' },
                        preview = { ' ', '', ' ', '', '', '', '', '' },
                    },

                    mappings = {
                        i = {
                            ["<esc>"] = require 'telescope.actions'.close,
                        },
                    },
                }
            }

            if config.plugins.telescope and type(config.plugins.telescope) == 'table' then
                opts = vim.tbl_deep_extend('force', opts, config.plugins.telescope)
            end

            local telescope = require 'telescope'
            telescope.setup(opts)
            telescope.load_extension('ast_grep')
            telescope.load_extension('file_browser')
            telescope.load_extension('fzf')
            telescope.load_extension('gh')
            telescope.load_extension('project')
            telescope.load_extension('tmux')
            telescope.load_extension('tusk')
            telescope.load_extension('ui-select')

            local builtin      = require 'telescope.builtin'
            local keymap       = require 'keymap'
            local file_browser = require 'telescope'.extensions.file_browser
            local ast_grep     = require 'telescope'.extensions.ast_grep
            local ivy_bufs     = require 'telescope.themes'.get_dropdown {
                layout_config         = { height = 15, width = 0.9999, anchor = 'N' },
                border                = true,
                ignore_current_buffer = true,
                sort_mru              = true,
                borderchars           = {
                    prompt  = { ' ', '', ' ', '', '', '', '', '' },
                    results = { ' ', '', '─', '', '', '', '', '' },
                    preview = { ' ', '', ' ', '', '', '', '', '' },
                },

                -- As an MRU buffer it's nice to be able to filter to a file by
                -- a single character, but many files with the same name might
                -- show so we show the full path as a suffix.
                ---@diagnostic disable-next-line: unused-local
                path_display = function(_, path)
                    local tail = require 'telescope.utils'.path_tail(path)
                    return string.format('%s (%s)', tail, path)
                end,
            }

            _G.HydraMappings["Root"]["Plugins"].f        = { 'Telescope',  function() keymap:runHydra('Telescope') end, { exit = true } }
            _G.HydraMappings["Telescope"]["Search"]['a'] = { 'AST', function() ast_grep.ast_grep({}) end, { exit = true } }
            _G.HydraMappings["Telescope"]["Search"]['*'] = { 'Word', function() builtin.grep_string() end, { exit = true } }
            _G.HydraMappings["Telescope"]["Search"]['/'] = { 'Grep', function() builtin.live_grep() end, { exit = true } }
            _G.HydraMappings["Telescope"]["Search"]['.'] = { 'Current Buffer', builtin.current_buffer_fuzzy_find, { exit = true } }

            _G.HydraMappings["Telescope"]["Git"].b = { 'Branches', function() builtin.git_branches() end, { exit = true }}
            _G.HydraMappings["Telescope"]["Git"].c = { 'Commits (Repo)', function() builtin.git_commits() end, { exit = true }}
            _G.HydraMappings["Telescope"]["Git"].C = { 'Commits (File)', function() builtin.git_bcommits() end, { exit = true }}
            _G.HydraMappings["Telescope"]["Git"].p = { 'Files (Repo)', function() builtin.git_files() end, { exit = true }}
            _G.HydraMappings["Telescope"]["Git"].f = { 'Files (CWD)', function() builtin.find_files() end, { exit = true }}
            _G.HydraMappings["Telescope"]["Git"].r = { 'Files (Relative)', function() builtin.find_files({ cwd = vim.fn.expand('%:p:h') }) end, { exit = true }}
            _G.HydraMappings["Telescope"]["Git"].s = { 'Status', function() builtin.git_status() end, { exit = true }}
            _G.HydraMappings["Telescope"]["Git"].z = { 'Stash',  function() builtin.git_stash() end,  { exit = true }}

            _G.HydraMappings["Telescope"]["Vim"].h = { 'Highlight Groups', function() builtin.highlights() end,   { exit = true }}
            _G.HydraMappings["Telescope"]["Vim"].j = { 'Buffers',          function() builtin.buffers(ivy_bufs) end, { exit = true }}
            _G.HydraMappings["Telescope"]["Vim"].k = { 'Keymaps',          function() builtin.keymaps() end,      { exit = true }}
            _G.HydraMappings["Telescope"]["Vim"].o = { 'Options',          function() builtin.vim_options() end,  { exit = true }}
            _G.HydraMappings["Telescope"]["Vim"].t = { 'Colorschemes',     function() builtin.colorscheme() end,  { exit = true }}
            _G.HydraMappings["Telescope"]["Vim"].x = { 'Commands',         function() builtin.commands() end,     { exit = true }}

            _G.HydraMappings["Telescope"]["LSP"].l     = { 'LSP', function() keymap:runHydra('Telescope LSP') end, { exit = true } }
            _G.HydraMappings["Telescope LSP"]["LSP"].c = { 'Incoming Calls',         function() builtin.lsp_incoming_calls() end,    { exit = true }}
            _G.HydraMappings["Telescope LSP"]["LSP"].C = { 'Outgoing Calls',         function() builtin.lsp_outgoing_calls() end,    { exit = true }}
            _G.HydraMappings["Telescope LSP"]["LSP"].d = { 'Definitions',            function() builtin.lsp_definitions() end,       { exit = true }}
            _G.HydraMappings["Telescope LSP"]["LSP"].i = { 'Implementations',        function() builtin.lsp_implementations() end,   { exit = true }}
            _G.HydraMappings["Telescope LSP"]["LSP"].r = { 'References',             function() builtin.lsp_references() end,        { exit = true }}
            _G.HydraMappings["Telescope LSP"]["LSP"].s = { 'Symbols (Current File)', function() builtin.lsp_document_symbols() end,  { exit = true }}
            _G.HydraMappings["Telescope LSP"]["LSP"].S = { 'Symbols (Project)',      function() builtin.lsp_workspace_symbols() end, { exit = true }}
            _G.HydraMappings["Telescope LSP"]["LSP"].t = { 'Type Definitions',       function() builtin.lsp_type_definitions() end,  { exit = true }}
            _G.HydraMappings["Telescope LSP"]["LSP"].l = { 'Diagnostics',            function() builtin.diagnostics() end,           { exit = true }}

            _G.HydraMappings["Telescope"]["Other"][" "] = { 'Resume',       function() builtin.resume() end, { exit = true }}
            _G.HydraMappings["Telescope"]["Other"].e    = { 'File Browser', function() file_browser.file_browser() end, { exit = true }}
            _G.HydraMappings["Telescope"]["Other"].q    = { 'Quit',         function() end,                             { exit = true }}

            _G.HydraMappings["Root"]["Other"].x = { 'Command Pallette',
                function()
                    local tusk = require 'telescope'.extensions.tusk
                    tusk.tusk()
                end,
                { exit = true }
            }
        end
    }
end
