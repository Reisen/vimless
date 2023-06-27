---@diagnostic disable: need-check-nil, redefined-local

M = {}

function M.generate(headers, hints)
    -- Before we do anything else we need to iterate over the columns to find
    -- the longest column array length.
    local longest = 0
    for _, header in ipairs(headers) do
        local column = hints[header]
        local column_size = 0
        for _ in pairs(column) do
            column_size = column_size + 1
        end
        if column_size > longest then
            longest = column_size
        end
    end

    -- Add header to length.
    longest = longest + 4

    -- We start by iterating over the columns, we can render each column into a
    -- list of lines, this way when we have a list of lines for each column we
    -- can worry about concatenating them together line-wise.
    local columns = {}
    for _, header in ipairs(headers) do
        local column = hints[header]

        -- Make sure column is a table.
        if type(column) == 'table' then
            -- We can now iterate over the column and render each line, we keep
            -- track of the maximum width for this column so we can pad it out
            -- at the end. Note that we start with the length of the header as
            -- our initial largest width.
            local width  = #header
            local lines  = {}
            for key, hint in pairs(column) do
                local line = string.format('%s: %s', key, hint[1])
                width = math.max(width, #line)
                table.insert(lines, line)
            end

            -- Now sort the lines and prefix with the original header.
            table.sort(lines)
            table.insert(lines, 1, '')
            table.insert(lines, 1, header)
            table.insert(lines, 1, '')

            -- Now we know the longest column is stored in `column`, and we want
            -- to append empty lines to the end of the current column until it is
            -- the same length
            while #lines < longest do
                table.insert(lines, '')
            end

            -- We can now iterate over the lines and pad them out to the width
            -- of the now known widest column.
            for i, line in ipairs(lines) do
                lines[i] = line .. string.rep(' ', width - #line)
            end

            -- We can now add the column to the list of columns.
            table.insert(columns, lines)
        end
    end

    -- We can now iterate over the lines and concatenate them together. As all
    -- columns are the same length we can just use the length of the first
    -- column to count.
    local lines = {}
    for i = 1, #columns[1] do
        local line = {}
        for _, column in ipairs(columns) do
            if column[i] ~= nil then
                table.insert(line, column[i] .. '    ')
            end
        end
        table.insert(lines, '    ' .. table.concat(line) .. '\n')
    end

    -- Append an empty line.
    table.insert(lines, '')

    -- Now we concat the result, and we'll use regex to wrap all matches with
    -- `_` characters.
    local result = table.concat(lines)
    return result:gsub('([%w%^%$%(%)%%%.%[%]%*%+%-%?=/<>]+):', '_%1_ ')
end

-- Given a Sectioned Table of Tables indexed by keycodes:
--
-- ```
-- {
--    ['Some Section'] = {
--        ['<leader>'] = { 'Some Hint', function() end, {} },
--        'a'          = { 'Some Hint', function() end, {} },
--    }
--    ...
-- }
-- ```
--
-- Flattens into a single array hydra expects. Note that the hint (the first
-- element of the array subkeys) should be replaced with the keycode like so:
--
-- ```
-- {
--    { '<leader>'],  function() end, {} },
--    { 'a',          function() end, {} },
--    ...
-- }
-- ```
function M.flatten(t)
    local result = {}
    for _, section in pairs(t) do
        for keycode, hint in pairs(section) do
            table.insert(result, { keycode, unpack(hint, 2) })
        end
    end
    return result
end

return function(config)
    if type(config.plugins.hydra) == 'boolean' and not config.plugins.hydra then
        return {}
    end

    return {
        'anuvyklack/hydra.nvim',
        dependencies = {
            'lewis6991/gitsigns.nvim',
            'nvim-lua/plenary.nvim',
            'saecki/crates.nvim',
            'simrat39/rust-tools.nvim',
        },
        config = function()
            if config.plugins.hydra and type(config.plugins.hydra) == 'function' then
                config.plugins.hydra()
                return
            end

            local hydra        = require 'hydra'
            local c            = require 'hydra.keymap-util'
            local p            = require 'plenary.strings'
            local gitsigns     = require 'gitsigns'
            local neotest      = require 'neotest'
            local file_browser = require 'telescope'.extensions.file_browser
            local octo         = require 'telescope'.extensions.octo
            local crates       = require 'crates'
            local rust_tools   = require 'rust-tools'
            local telescope    = require 'telescope.builtin'
            local bufremove    = require 'mini.bufremove'

            -- Wrap the Hydra call with a generator that consumes and formats
            -- hints before the creating the full hydra.
            local genhydra = function(hints)
                local order = hints.order or {}
                hints.hint  = M.generate(order, hints.heads)
                hints.heads = M.flatten(hints.heads)
                local neck = hydra(hints)
                neck.win_width = vim.o.columns
                return hydra(hints)
            end

            -- Hint Options that are shared by all Hydras.
            local hint_options = {
                position = 'bottom',
                border   = 'none',
                offset   = 0,
            }

            local window_hydra = genhydra({
                name   = 'Window Management',
                mode   = 'n',
                body   = '<leader>w',
                config = {
                    hint           = hint_options,
                    invoke_on_body = true,
                },
                order = {
                    "Window Navigation",
                    "Window Swapping",
                    "Window Resizing",
                    "Window Splitting",
                    "Other",
                },
                heads  = {
                    ["Window Navigation"] = {
                        h = {'Left',  c.cmd('wincmd h'), {}},
                        j = {'Down',  c.cmd('wincmd j'), {}},
                        k = {'Up',    c.cmd('wincmd k'), {}},
                        l = {'Right', c.cmd('wincmd l'), {}},
                        o = {'Jump to Window', function() _G.LeapToWindow() end, { exit = true }},
                    },
                    ["Window Swapping"] = {
                        H = {'Swap Left',     c.cmd('wincmd H'), {}},
                        J = {'Swap Down',     c.cmd('wincmd J'), {}},
                        K = {'Swap Up',       c.cmd('wincmd K'), {}},
                        L = {'Swap Right',    c.cmd('wincmd L'), {}},
                        x = {'Swap Previous', c.cmd('wincmd x'), {}},
                    },
                    ["Window Resizing"] = {
                        ["-"] = {'Decrease Height', c.cmd('resize -1'), {}},
                        ["+"] = {'Increase Height', c.cmd('resize +1'), {}},
                        ["<"] = {'Decrease Width',  c.cmd('vertical resize -1'), {}},
                        [">"] = {'Increase Width',  c.cmd('vertical resize +1'), {}},
                        ["="] = {'Balance Windows', c.cmd('wincmd ='), {}},
                    },
                    ["Window Splitting"] = {
                        s = {'Split Horizontal', c.cmd('wincmd s'), {}},
                        v = {'Split Vertical',   c.cmd('wincmd v'), {}},
                    },
                    ["Other"] = {
                        c = {'Close Window',       c.cmd('wincmd c'), {}},
                        T = {'Move Window to Tab', c.cmd('wincmd T'), { exit = true }},
                        q = {'Quit',               function() end,    { exit = true }},
                    }
                },
            })

            -- Initialize Hydras
            local tab_hydra = genhydra({
                name   = 'Tab Management',
                mode   = 'n',
                body   = '<leader>t',
                config = {
                    hint           = hint_options,
                    invoke_on_body = true,
                },
                order = {
                    "Tab Navigation",
                    "Tab Swapping",
                    "Other",
                },
                heads  = {
                    ["Tab Navigation"] = {
                        ["0"] = {'First', c.cmd('tabfirst'), {}},
                        ["9"] = {'Last',  c.cmd('tablast'),  {}},
                        h     = {'Prev',  c.cmd('tabprev'), {}},
                        l     = {'Next',  c.cmd('tabnext'), {}},
                    },
                    ["Tab Swapping"] = {
                        H     = {'Move Tab Left',  c.cmd('tabmove -'), {}},
                        L     = {'Move Tab Right', c.cmd('tabmove +'), {}},
                    },
                    ["Other"] = {
                        c = {'Close Tab', c.cmd('tabclose'), {}},
                        n = {'New Tab',   c.cmd('tabnew'),   {}},
                        q = {'Quit',      function() end,     { exit = true }},
                    }
                },
            })

            local buffer_hydra = genhydra({
                name   = 'Buffer Management',
                mode   = 'n',
                body   = '<leader>b',
                config = {
                    hint           = hint_options,
                    invoke_on_body = true,
                },
                order = {
                    'Buffer Navigation',
                    'Other',
                },
                heads  = {
                    ["Buffer Navigation"] = {
                        ['1'] = { 'First',    c.cmd('bfirst'), {}},
                        h     = { 'Previous', c.cmd('bprev'),  {}},
                        l     = { 'Next',     c.cmd('bnext'),  {}},
                        ['9'] = { 'Last',     c.cmd('blast'),  {}},
                    },

                    ["Other"] = {
                        d = { 'Delete Buffer',        bufremove.delete,    { exit = true }},
                        o = { 'Delete Other Buffers', c.cmd('%bd|e#|bd#'), { exit = true }},
                        q = { 'Quit',                 function() end,      { exit = true }},
                    }

                },
            })

            -- We wrap the Hydra generation in a function because by default Hydra's
            -- are created once at module load, which means they do not have buffer
            -- local context. Instead we bind this function to an autocommand that
            -- generates the hydras per-buffer.
            --
            -- TODO: Only split out hydras that can't be global.
            function _G.VimlessBindHydras()
                local git_hydra = genhydra({
                    name   = 'Git',
                    mode   = {'n', 'x'},
                    body   = '<leader>g',
                    config = {
                        hint           = hint_options,
                        invoke_on_body = true,
                        buffer         = true,
                        on_key         = function() vim.wait(50) end,
                    },
                    order = {
                        "Diff",
                        "Visual",
                        "Git",
                        "Other",
                    },
                    heads  = {
                        ["Diff"] = {
                            n = { 'Next Hunk',  function() vim.cmd 'Gitsigns next_hunk' end,  {}},
                            p = { 'Prev Hunk',  function() vim.cmd 'Gitsigns prev_hunk' end,  {}},
                            r = { 'Reset Hunk', function() vim.cmd 'Gitsigns reset_hunk' end, {}},
                            s = { 'Stage Hunk',
                                function()
                                    local mode = vim.api.nvim_get_mode().mode:sub(1,1)
                                    if mode == 'V' then -- visual-line mode
                                       local esc = vim.api.nvim_replace_termcodes('<Esc>', true, true, true)
                                       vim.api.nvim_feedkeys(esc, 'x', false) -- exit visual mode
                                       vim.cmd("'<,'>Gitsigns stage_hunk")
                                    else
                                       vim.cmd("Gitsigns stage_hunk")
                                    end
                                end,
                                {}
                            },
                            R = { 'Reset Buffer',        gitsigns.reset_buffer,    {}},
                            S = { 'Stage Buffer',        gitsigns.stage_buffer,    {}},
                            u = { 'Undo Stage Hunk',     gitsigns.undo_stage_hunk, {}},
                            d = { 'Diff (Project)',      function() vim.cmd 'DiffviewFileHistory %' end, { exit = true }},
                            D = { 'Diff (Current File)', function() vim.cmd 'DiffviewOpen' end,          { exit = true }},
                        },

                        ["Visual"] = {
                            b = { 'Blame Current Line', function() gitsigns.blame_line { full = true } end, { exit = true }},
                            B = { 'Blame Buffer',       function() vim.cmd 'G blame' end,                   { exit = true }},
                            v = { 'Highlight Numbers',  function() vim.cmd 'Gitsigns toggle_linehl' end,    { exit = true }},
                            V = { 'Highlight Lines',    function() vim.cmd 'Gitsigns toggle_numhl' end,     { exit = true }},
                        },

                        ["Git"] = {
                            e = { 'Git Status', function() vim.cmd 'Gedit:' end,          { exit = true }},
                            l = { 'Git Log',    function() vim.cmd 'G log --oneline' end, { exit = true }},
                        },

                        ["Other"] = {
                            g = { 'LazyGit', function() vim.cmd 'LazyGit' end, { exit = true }},
                            q = { 'Quit',    function() end, { exit = true }},
                        },
                    },
                })

                local neotest_hydra = genhydra({
                    name   = 'Neotest',
                    mode   = {'n'},
                    body   = '<leader>n',
                    config = {
                        hint           = hint_options,
                        buffer         = true,
                        invoke_on_body = true,
                    },
                    order = {
                        "Run",
                        "Output",
                        "Other",
                    },
                    heads  = {
                        ["Run"] = {
                            ["."] = { 'Run Test',          neotest.run.run,                                    { exit = true }},
                            f     = { 'Run File Tests',    function() neotest.run.run(vim.fn.expand('%')) end, { exit = true }},
                            s     = { 'Stop Running Test', neotest.run.stop,                                   { exit = true }},
                            a     = { 'Attach to Test ',   neotest.run.attach,                                 { exit = true }},
                        },

                        ["Output"] = {
                            o = { 'Toggle Overview', neotest.summary.toggle,      { exit = true }},
                            p = { 'Toggle Panel',    neotest.output_panel.toggle, { exit = true }},
                        },

                        ["Other"] = {
                            q = { 'Quit', function() end, { exit = true }},
                        },
                    },
                })

                local rust_hydra = genhydra({
                    name   = 'Rust',
                    mode   = 'n',
                    body   = '<leader>r',
                    config = {
                        hint           = hint_options,
                        invoke_on_body = true,
                        buffer         = true,
                        on_key         = function() vim.wait(50) end,
                    },
                    order = {
                        "Crates",
                        "Source",
                        "Other",
                    },
                    heads = {
                        ["Crates"] = {
                            u = { 'Update Crate',  crates.update_crate,            { exit = true }},
                            U = { 'Upgrade Crate', crates.upgrade_crate,           { exit = true }},
                            i = { 'Update Crate',  crates.show_popup,              { exit = true }},
                            d = { 'Update Crate',  crates.show_dependencies_popup, { exit = true }},
                            o = { 'Update Crate',  crates.show_features_popup,     { exit = true }},
                            v = { 'Update Crate',  crates.show_versions_popup,     { exit = true }},
                        },

                        ["Source"] = {
                            k = { 'Move Item Up',    rust_tools.move_item.move_up,               { exit = true }},
                            j = { 'Move Item Down',  rust_tools.move_item.move_down,             { exit = true }},
                            e = { 'Expand Macro',    rust_tools.expand_macro.expand_macro,       { exit = true }},
                            s = { 'Parent Module',   rust_tools.parent_module.parent_module,     { exit = true }},
                            c = { 'Open Cargo.toml', rust_tools.open_cargo_toml.open_cargo_toml, { exit = true }},
                        },

                        ["Other"] = {
                            q = { 'Quit', function() end, { exit = true }},
                        }
                    },
                })

                local lsp_hydra = genhydra({
                    name   = 'LSP',
                    mode   = 'n',
                    body   = '<leader>l',
                    color  = 'pink',
                    config = {
                        hint           = hint_options,
                        invoke_on_body = true,
                        buffer         = true,
                        on_key         = function() vim.wait(50) end,
                    },
                    order = {
                        'Diagnostics',
                        'Goto',
                        'Refactoring',
                        'Other',
                    },
                    heads = {
                        ["Diagnostics"] = {
                            n = { 'Next Error',  vim.diagnostic.goto_next,  { exit = true }},
                            p = { 'Prev Error',  vim.diagnostic.goto_prev,  { exit = true }},
                            l = { 'List Errors', vim.diagnostic.setloclist, { exit = true }},
                        },

                        ["Goto"] = {
                            D = { 'Declaration',          vim.lsp.buf.declaration,     { exit = true }},
                            K = { 'Documentation',        vim.lsp.buf.hover,           { exit = true }},
                            d = { 'Definition',           vim.lsp.buf.definition,      { exit = true }},
                            i = { 'Implementations',      vim.lsp.buf.implementation,  { exit = true }},
                            r = { 'References',           vim.lsp.buf.references,      { exit = true }},
                            t = { 'Type Definitions',     vim.lsp.buf.type_definition, { exit = true }},
                            s = { 'Definition in Split', function()
                                -- This opens a split to the right with the cursor
                                -- in the same space. It then focuses that window,
                                -- and invokes vim.lsp.definition to go to the
                                -- file. It will then call `zt` to move it to the
                                -- top of the file.
                                vim.cmd 'wincmd v'
                                vim.cmd 'wincmd l'
                                vim.lsp.buf.definition()
                                vim.wait(50)
                                vim.cmd 'norm zt'
                            end, { exit = true }},
                        },

                        ["Refactoring"] = {
                            a = { 'Actions',     vim.lsp.buf.code_action, { exit = true }},
                            f = { 'Format File', vim.lsp.buf.formatting,  { exit = true }},
                            R = { 'Rename',      vim.lsp.buf.rename,      { exit = true }},
                        },

                        ["Other"] = {
                            m = { 'Mason', c.cmd('Mason'), { exit = true }},
                            q = { 'Quit', function() end, { exit = true }},
                        }
                    }
                })

                local ivy = require 'telescope.themes'.get_dropdown {
                    border        = true,
                    layout_config = { height = 15, width = 0.9999, anchor = 'N' },
                    borderchars   = {
                        prompt  = { ' ', ' ', '', ' ', '', '', '', '' },
                        results = { '',  ' ', '', ' ', '', '', '', '' },
                        preview = { '',  ' ', '', ' ', '', '', '', '' },
                    },
                }

                local cursor = require 'telescope.themes'.get_cursor {
                    border        = true,
                    layout_config = { height = 15 },
                    borderchars   = {
                        prompt  = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
                        results = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
                        preview = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
                    },
                }

                -- Settings for Ivy for an MRU list. This list is intended to only
                -- show the file name and set fuzzy completion to exact such that
                -- quick switching based on file name can be done in a single
                -- keystroke.
                local ivy_bufs  = require 'telescope.themes'.get_dropdown {
                    layout_config         = { height = 15, width = 0.9999, anchor = 'N' },
                    border                = true,
                    ignore_current_buffer = true,
                    sort_mru              = true,
                    borderchars           = {
                        prompt  = { '─', ' ', '', ' ', '', '', '', '' },
                        results = { '',  ' ', '', ' ', '', '', '', '' },
                        preview = { '',  ' ', '', ' ', '', '', '', '' },
                    },

                    -- As an MRU buffer it's nice to be able to filter to a file by
                    -- a single character, but many files with the same name might
                    -- show so we show the full path as a suffix.
                    path_display = function(opts, path)
                        local tail = require 'telescope.utils'.path_tail(path)
                        return string.format('%s (%s)', tail, path)
                    end,
                }

                local fzf_hydra = genhydra({
                    name  = 'FZF',
                    mode  = 'n',
                    body  = '<leader>f',
                    config = {
                        hint           = hint_options,
                        buffer         = true,
                        invoke_on_body = true,
                    },
                    order = {
                        'Search',
                        'LSP',
                        'Git',
                        'Vim',
                        'Other',
                    },
                    heads = {
                        ["Search"] = {
                            ['*'] = {'Word',           function() telescope.grep_string(cursor) end,            { exit = true }},
                            ['/'] = {'Grep',           function() telescope.live_grep(ivy) end,                 { exit = true }},
                            ['.'] = {'Current Buffer', function() telescope.current_buffer_fuzzy_find(ivy) end, { exit = true }},
                        },

                        ["Git"] = {
                            b = { 'Branches',             function() telescope.git_branches(ivy) end, { exit = true }},
                            c = { 'Commits',              function() telescope.git_commits(ivy) end,  { exit = true }},
                            C = { 'Current File Commits', function() telescope.git_bcommits(ivy) end, { exit = true }},
                            p = { 'Files (Entire Repo)',  function() telescope.git_files(ivy) end,    { exit = true }},
                            f = { 'Files (CWD)',          function() telescope.find_files(ivy) end,   { exit = true }},
                            r = { 'Files (Relative)',
                                function()
                                    -- Modify `ivy` to contain `cwd` that points to the current directory
                                    -- of the file open in the current buffer. We clone `ivy` first so we
                                    -- don't mutate it for other heads.
                                    --
                                    -- The vim.fn.expand call uses `:%:p:h` which means:
                                    --
                                    --  %   - The current file name
                                    --  :p  - Make it an absolute path
                                    --  :h  - Remove the file name, leaving only the path
                                    local ivy = vim.deepcopy(ivy)
                                    ivy.cwd = vim.fn.expand('%:p:h')
                                    telescope.find_files(ivy)
                                end,
                                { exit = true }
                            },
                            s = { 'Status', function() telescope.git_status(ivy) end, { exit = true }},
                            z = { 'Stash',  function() telescope.git_stash(ivy) end,  { exit = true }},
                        },

                        ["Vim"] = {
                            h = { 'Highlight Groups', function() telescope.highlights(ivy) end,   { exit = true }},
                            j = { 'Buffers',          function() telescope.buffers(ivy_bufs) end, { exit = true }},
                            k = { 'Keymaps',          function() telescope.keymaps(ivy) end,      { exit = true }},
                            o = { 'Options',          function() telescope.vim_options(ivy) end,  { exit = true }},
                            t = { 'Colorschemes',     function() telescope.colorscheme(ivy) end,  { exit = true }},
                            x = { 'Commands',         function() telescope.commands(ivy) end,     { exit = true }},
                        },

                        ["LSP"] = {
                            lc = { 'Incoming Calls',         function() telescope.lsp_incoming_calls(ivy) end,    { exit = true }},
                            lC = { 'Outgoing Calls',         function() telescope.lsp_outgoing_calls(ivy) end,    { exit = true }},
                            ld = { 'Definitions',            function() telescope.lsp_definitions(ivy) end,       { exit = true }},
                            li = { 'Implementations',        function() telescope.lsp_implementations(ivy) end,   { exit = true }},
                            lr = { 'References',             function() telescope.lsp_references(ivy) end,        { exit = true }},
                            ls = { 'Symbols (Current File)', function() telescope.lsp_document_symbols(ivy) end,  { exit = true }},
                            lS = { 'Symbols (Project)',      function() telescope.lsp_workspace_symbols(ivy) end, { exit = true }},
                            lt = { 'Type Definitions',       function() telescope.lsp_type_definitions(ivy) end,  { exit = true }},
                            ll = { 'Diagnostics',            function() telescope.diagnostics(ivy) end,           { exit = true }},
                        },

                        ["Other"] = {
                            e = { 'File Browser', function() file_browser.file_browser(ivy) end, { exit = true }},
                            q = { 'Quit',         function() end,                                { exit = true }},
                        },
                    }
                })

                local octo_hydra = genhydra({
                    name  = 'Octo',
                    mode  = 'n',
                    body  = '<leader>o',
                    config = {
                        hint           = hint_options,
                        invoke_on_body = true,
                        buffer         = true,
                    },
                    order = {
                        'Github',
                        'Other',
                    },
                    heads = {
                        ["Github"] = {
                            g = { 'Gists',  function() octo.gists(ivy) end,  { exit = true }},
                            i = { 'Issues', function() octo.issues(ivy) end, { exit = true }},
                            p = { 'PRs',    function() octo.prs(ivy) end,    { exit = true }},
                            r = { 'Repos',  function() octo.repos(ivy) end,  { exit = true }},
                        },

                        ["Other"] = {
                            s = { 'Search', function() octo.search(ivy) end, { exit = true }},
                            q = { 'Quit',   function() end,                  { exit = true }},
                        }
                    }
                })

                genhydra({
                    name   = 'Hydra',
                    mode   = 'n',
                    body   = '<leader>h',
                    config = {
                        hint           = hint_options,
                        invoke_on_body = true,
                        buffer         = true,
                    },
                    order = {
                        'Vim',
                        'Plugins',
                        'Languages',
                        'UI',
                        'Other',
                    },
                    heads = {
                        ["Vim"] = {
                            b = { 'Buffers', function() buffer_hydra:activate() end, { exit = true }},
                            l = { 'LSP',     function() lsp_hydra:activate() end,    { exit = true }},
                            t = { 'Tabs',    function() tab_hydra:activate() end,    { exit = true }},
                            w = { 'Windows', function() window_hydra:activate() end, { exit = true }},
                        },

                        ["Plugins"] = {
                            f = { 'Telescope', function() fzf_hydra:activate() end,     { exit = true }},
                            g = { 'Git',       function() git_hydra:activate() end,     { exit = true }},
                            n = { 'Neotest',   function() neotest_hydra:activate() end, { exit = true }},
                            o = { 'Octo',      function() octo_hydra:activate() end,    { exit = true }},
                        },

                        ["Languages"] = {
                            r = { 'Rust', function() rust_hydra:activate() end, { exit = true }},
                        },

                        ["UI"] = {
                            sp = { 'Toggle Plugin Manager', c.cmd('Lazy'), { exit = true }},
                            st = { 'Toggle Trouble',        c.cmd('TroubleToggle'),             { exit = true }},
                            sn = { 'Toggle Neotree',        c.cmd('NeoTreeShowToggle buffers'), { exit = true }},
                        },

                        ["Other"] = {
                            q = { 'Quit',     function() end,  { exit = true }},
                            k = { 'WhichKey', ':WhichKey<cr>', { exit = true }},
                        }
                    }
                })
            end

            -- Now we create an autocommand that binds these every time a new buffer
            -- is created.
            vim.cmd [[
                augroup hydra
                    autocmd!
                    autocmd BufEnter * lua VimlessBindHydras()
                augroup

                " Some Hydra's (in particular those in the h window) that do
                " not invoke other hydras need to be bound manually.
                nnoremap <leader>k :WhichKey<cr>
                nnoremap <leader>p :Lazy<cr>
            ]]
        end
    }
end
