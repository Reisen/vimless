---@diagnostic disable: need-check-nil, redefined-local

M = {}

function M.generate(headers, hints)
    -- Before we do anything else we need to iterate over the columns to find
    -- the longest column array length.
    local longest = 0
    for _, column in ipairs(hints) do
        if #column > longest then
            longest = #column
        end
    end

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
            -- our minimum.
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

            -- We now need to add empty lines if needed to fill the column so it
            -- is as long as the longest column. Note that we inserted new lines
            -- so longest should be adjusted also.
            local adjustment = #lines - longest - 2
            for _ = 1, adjustment do
                table.insert(lines, '')
            end

            -- We can now iterate over the lines and pad them out to the width of
            -- the column (+4 chars to separate the column from the next).
            for i, line in ipairs(lines) do
                lines[i] = line .. string.rep(' ', width - #line + 4)
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
            table.insert(line, column[i])
        end
        table.insert(lines, table.concat(line) .. '\n')
    end

    -- Now we concat the result, and we'll use regex to wrap all matches with
    -- `_` characters.
    local result = table.concat(lines)
    return result:gsub('([%w%^%$%(%)%%%.%[%]%*%+%-%?=]+):', '_%1_ ')
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

return function(use)
    use {
        'anuvyklack/hydra.nvim',
        requires = {
            'lewis6991/gitsigns.nvim',
            'nvim-lua/plenary.nvim',
            'saecki/crates.nvim',
        },
        config = function()
            local hydra       = require 'hydra'
            local c           = require 'hydra.keymap-util'
            local p           = require 'plenary.strings'
            local rust        = require 'rust-tools'
            local gitsigns    = require 'gitsigns'
            local genhydra    = function(hints)
                local order       = hints.order or {}
                hints.hint        = M.generate(order, hints.heads)
                hints.heads       = M.flatten(hints.heads)
                return hydra(hints)
            end

            -- Hydra of Hydras
            local hydra_hint = p.dedent [[
                ^ Hydras
                ^ _b_: Buffers
                ^ _f_: FZF / Search
                ^ _g_: Git
                ^ _l_: LSP
                ^ _o_: Octo / Github
                ^ _r_: Rust
                ^ _t_: Tabs
                ^ _v_: Vim
                ^ _w_: Windows

                ^ _q_: Quit ]]

            -- Buffer Related Hints
            local buffer_hint = p.dedent [[
                ^ General                     Navigation ^
                ^ _d_: Delete Focus Buffer    _1_: First Buffer ^
                ^ _o_: Delete Other Buffers   _9_: Last Buffer 
                ^ _q_: Quit                   _h_: Prev Buffer 
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^_l_: Next Buffer ^]]

            -- Git Related Hints
            local git_hint = p.dedent [[
                ^ Navigation
                ^ _p_: Prev Hunk
                ^ _n_: Next Hunk

                ^ Staging
                ^ _s_: Stage Hunk
                ^ _S_: Stage File
                ^ _r_: Reset Hunk
                ^ _R_: Reset File
                ^ _u_: Undo Stage

                ^ Diffing
                ^ _b_: Blame (_B_: Blame Line)
                ^ _d_: Diff Highlight
                ^ _D_: Diff Highlight Line
                ^ _v_: Diff File (_V_: Repository) ^
                ^ _e_: Git Edit View
                ^ _l_: Git Log View

                ^ _q_: Quit ]]

            -- Rust Related Hints
            local rust_hint = p.dedent [[
                ^ Actions
                ^ _e_: Expand Macro
                ^ _k_: Move Item Up
                ^ _j_: Move Item Down

                ^ Crates
                ^ _u_: Update Crate (_U_: Upgrade) ^
                ^ _i_: Show Crate Info
                ^ _d_: Show Crate Dependencies
                ^ _o_: Show Crate Options/Features
                ^ _v_: Show Crate Versions

                ^ Navigation
                ^ _c_: Goto Cargo.toml
                ^ _s_: Goto Super Module
                ^ _q_: Quit ]]

            -- Vim Hints
            local vim_hint = p.dedent [[
                ^ Packer
                ^ _pc_: Compile Plugins ^
                ^ _ps_: Sync Plugins
                ^ _p?_: Plugin Info

                ^ General
                ^ _c_:  Toggle Codemap
                ^ _m_:  Open Mason
                ^ _t_:  Toggle Trouble
                ^ _q_:  Quit ]]

            -- LSP Hints
            local lsp_hint = p.dedent [[
                ^ Navigation
                ^ _d_: Goto Definition (_D_: Declaration) ^
                ^ _i_: Goto Implementation
                ^ _n_: Next Diagnostic
                ^ _p_: Prev Diagnostic
                ^ _t_: Type Definition

                ^ LSP Actions
                ^ _a_: Code Action
                ^ _f_: Format File
                ^ _K_: Documentation
                ^ _l_: Diagnostics Loclist
                ^ _r_: References            
                ^ _R_: Rename

                ^ _q_: Quit ]]

            -- FZF Hints
            local fzf_hint = p.dedent [[
                ^ Navigation
                ^ _j_:  Jump to Buffer
                ^ _*_:  Grep Word Under Cursor
                ^ _/_:  Grep
                ^ _e_:  File Explorer
                ^ _h_:  Harpoon
                ^ _p_:  Projects
                ^ _n_:  TODO / Notes

                ^ Git Related
                ^ _b_:  Git Branches
                ^ _c_:  Git Commits (_C_: File) ^
                ^ _f_:  Git Files
                ^ _s_:  Git Status
                ^ _z_:  Git Stash

                ^ LSP
                ^ _ll_: LSP Diagnostics
                ^ _ld_: LSP Definitions
                ^ _lt_: LSP Types
                ^ _lr_: LSP References         
                ^ _li_: LSP Implementations
                ^ _ls_: LSP Symbols
                ^ _lS_: LSP Symbols (Workspace)
                ^ _lc_: LSP Incoming Calls
                ^ _lC_: LSP Outgoing Calls

                ^ General
                ^ _o_:  Vim Options
                ^ _r_:  Vim Registers
                ^ _t_:  Colorscheme Switcher
                ^ _q_:  Quit ]]

            -- Octo Hints
            local octo_hint = p.dedent [[
                ^ Navigation
                ^ _g_: Gists
                ^ _i_: Issues
                ^ _p_: Pull Requests
                ^ _r_: Repos
                ^ _s_: Search

                ^ _q_:  Quit ]]

            -- Hint Options that are shared by all Hydras.
            local hint_options = {
                position = 'top',
                border   = 'solid',
                offset   = 0,
            }

            -- Initialize Hydras
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
                    "Window Splitting",
                    "Other",
                },
                heads  = {
                    ["Window Navigation"] = {
                        h = {'Left',             c.cmd('wincmd h'), {}},
                        j = {'Down',             c.cmd('wincmd j'), {}},
                        k = {'Up',               c.cmd('wincmd k'), {}},
                        l = {'Right',            c.cmd('wincmd l'), {}},
                        o = {'Focus Other',      c.cmd('wincmd o'), {}},
                    },
                    ["Window Swapping"] = {
                        H = {'Swap Left',        c.cmd('wincmd H'), {}},
                        J = {'Swap Down',        c.cmd('wincmd J'), {}},
                        K = {'Swap Up',          c.cmd('wincmd K'), {}},
                        L = {'Swap Right',       c.cmd('wincmd L'), {}},
                        x = {'Swap Previous',    c.cmd('wincmd x'), {}},
                    },
                    ["Window Splitting"] = {
                        s = {'Split Horizontal', c.cmd('wincmd s'), {}},
                        v = {'Split Vertical',   c.cmd('wincmd v'), {}},
                    },
                    ["Other"] = {
                        c     = {'Close Window',       c.cmd('wincmd c'), {}},
                        T     = {'Move Window to Tab', c.cmd('wincmd T'), { exit = true }},
                        ["="] = {'Balance Windows',    c.cmd('wincmd ='), {}},
                        q     = {'Quit',               function() end,    { exit = true }},
                    }
                },
            })

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

            local buffer_hydra = hydra({
                name   = 'Buffer Management',
                mode   = 'n',
                body   = '<leader>b',
                hint   = buffer_hint,
                config = {
                    hint           = hint_options,
                    invoke_on_body = true,
                },
                heads  = {
                    {'1', c.cmd('bfirst'),     {}},
                    {'h', c.cmd('bprev'),      {}},
                    {'l', c.cmd('bnext'),      {}},
                    {'9', c.cmd('blast'),      {}},

                    {'d', c.cmd('bdel'),       { exit = true }},
                    {'o', c.cmd('%bd|e#|bd#'), { exit = true }},
                    {'q', nil,                 { exit = true }},
                },
            })

            local git_hydra = hydra({
                name   = 'Git',
                mode   = {'n', 'x'},
                body   = '<leader>g',
                hint   = git_hint,
                config = {
                    hint           = hint_options,
                    invoke_on_body = true,
                    on_key         = function() vim.wait(50) end,
                },
                heads  = {
                    { 'n', function() vim.cmd 'Gitsigns next_hunk' end,  {}},
                    { 'p', function() vim.cmd 'Gitsigns prev_hunk' end,  {}},
                    { 'r', function() vim.cmd 'Gitsigns reset_hunk' end, {}},
                    { 's',
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
                    { 'R', gitsigns.reset_buffer,                              {}},
                    { 'S', gitsigns.stage_buffer,                              {}},
                    { 'u', gitsigns.undo_stage_hunk,                           {}},

                    { 'b', function() gitsigns.blame_line { full = true } end, { exit = true }},
                    { 'B', function() vim.cmd 'G blame' end,                   { exit = true }},
                    { 'd', function() vim.cmd 'Gitsigns toggle_linehl' end,    { exit = true }},
                    { 'D', function() vim.cmd 'Gitsigns toggle_numhl' end,     { exit = true }},
                    { 'e', function() vim.cmd 'Gedit:' end,                    { exit = true }},
                    { 'l', function() vim.cmd 'G log --oneline' end,           { exit = true }},
                    { 'v', function() vim.cmd 'DiffviewFileHistory %' end,     { exit = true }},
                    { 'V', function() vim.cmd 'DiffviewOpen' end,              { exit = true }},
                    { 'q', nil,                                                { exit = true }},
                },
            })

            local rust_hydra = hydra({
                name   = 'Rust',
                mode   = 'n',
                body   = '<leader>r',
                hint   = rust_hint,
                config = {
                    hint           = hint_options,
                    invoke_on_body = true,
                    on_key         = function() vim.wait(50) end,
                },
                heads  = {
                    { 'k', rust.move_item and rust.move_item.move_up or function()end,                     { exit = true }},
                    { 'j', rust.move_item and rust.move_item.move_down or function()end,                   { exit = true }},
                    { 'e', rust.expand_macro and rust.expand_macro.expand_macro or function()end,          { exit = true }},
                    { 's', rust.parent_module and rust.parent_module.parent_module or function()end,       { exit = true }},
                    { 'c', rust.open_cargo_toml and rust.open_cargo_toml.open_cargo_toml or function()end, { exit = true }},

                    { 'u', require('crates').update_crate,            { exit = true }},
                    { 'U', require('crates').upgrade_crate,           { exit = true }},
                    { 'i', require('crates').show_popup,              { exit = true }},
                    { 'd', require('crates').show_dependencies_popup, { exit = true }},
                    { 'o', require('crates').show_features_popup,     { exit = true }},
                    { 'v', require('crates').show_versions_popup,     { exit = true }},

                    { 'q', nil,                                       { exit = true }},
                },
            })

            local vim_hydra = genhydra({
                name   = 'VIM',
                mode   = 'n',
                body   = '<leader>v',
                config = {
                    hint           = hint_options,
                    invoke_on_body = true,
                },
                order = {
                    'Packer',
                    'Toggle',
                    'Other',
                },
                heads  = {
                    ["Packer"] = {
                        pc     = { 'Compile Config', c.cmd('PackerCompile'), { exit = true }},
                        ps     = { 'Sync Config',    c.cmd('PackerSync'),    { exit = true }},
                        pu     = { 'Update Config',  c.cmd('PackerStatus'),  { exit = true }},
                        ["p?"] = { 'Status',         c.cmd('PackerStatus'),  { exit = true }},
                    },

                    ["Toggle"] = {
                        m = { 'Toggle Minimap', require'mini.map'.toggle,     { exit = true }},
                        t = { 'Toggle Trouble', c.cmd('TroubleToggle'),       { exit = true }},
                        n = { 'Toggle Neotree', c.cmd('NeoTreeRevealToggle'), { exit = true }},
                    },

                    ["Other"] = {
                        q = { 'Quit',  nil,            { exit = true }},
                    }
                }
            })

            local lsp_hydra = genhydra({
                name   = 'LSP',
                mode   = 'n',
                body   = '<leader>l',
                color  = 'pink',
                config = {
                    hint           = hint_options,
                    invoke_on_body = true,
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
                        D = { 'Declaration',      vim.lsp.buf.declaration,     { exit = true }},
                        K = { 'Documentation',    vim.lsp.buf.hover,           { exit = true }},
                        d = { 'Definition',       vim.lsp.buf.definition,      { exit = true }},
                        i = { 'Implementations',  vim.lsp.buf.implementation,  { exit = true }},
                        r = { 'References',       vim.lsp.buf.references,      { exit = true }},
                        t = { 'Type Definitions', vim.lsp.buf.type_definition, { exit = true }},
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

            -- Create Telescope and Theme objects for use in the Hydra
            local telescope = require'telescope.builtin'

            local ivy = require'telescope.themes'.get_dropdown {
                border        = true,
                layout_config = { height = 20, width = 0.999, anchor = 'N' },
                offset        = { 0, 0 },
                borderchars   = {
                    prompt  = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
                    results = { ' ', ' ', '─', ' ', ' ', ' ', ' ', ' ' },
                    preview = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
                },
            }

            local cursor = require'telescope.themes'.get_cursor {
                border        = true,
                layout_config = { height = 20 },
                borderchars   = {
                    prompt  = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
                    results = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
                    preview = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
                },
            }

            -- Ivy but with sort_mru included in the options.
            local ivy_bufs  = require'telescope.themes'.get_dropdown {
                sort_mru              = true,
                ignore_current_buffer = true,
                layout_config         = { height = 20, width = 0.99, anchor = 'N' },
                borderchars           = {
                    prompt  = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
                    results = { ' ', ' ', '─', ' ', ' ', ' ', ' ', ' ' },
                    preview = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
                },
            }

            -- Extensions
            local file_browser = require'telescope'.extensions.file_browser
            local harpoon      = require'telescope'.extensions.harpoon
            local octo         = require'telescope'.extensions.octo
            local projects     = require'telescope'.extensions.project
            local todo         = require'telescope'.extensions['todo-comments']

            local fzf_hydra = hydra({
                name  = 'FZF',
                mode  = 'n',
                body  = '<leader>f',
                hint  = fzf_hint,
                config = {
                    hint           = hint_options,
                    invoke_on_body = true,
                },
                heads = {
                    { '*',  function() telescope.grep_string(cursor) end,            { exit = true }},
                    { '/',  function() telescope.live_grep(ivy) end,                 { exit = true }},
                    { 'b',  function() telescope.git_branches(ivy) end,              { exit = true }},
                    { 'C',  function() telescope.git_bcommits(ivy) end,              { exit = true }},
                    { 'c',  function() telescope.git_commits(ivy) end,               { exit = true }},
                    { 'e',  function() file_browser.file_browser(ivy) end,           { exit = true }},
                    { 'f',  function() telescope.git_files(ivy) end,                 { exit = true }},
                    { 'h',  function() harpoon.marks(ivy) end,                       { exit = true }},
                    { 'j',  function() telescope.buffers(ivy_bufs) end,              { exit = true }},
                    { 'n',  function() todo.todo(ivy) end,                           { exit = true }},
                    { 'o',  function() telescope.vim_options(ivy) end,               { exit = true }},
                    { 'p',  function() projects.project(ivy) end,                    { exit = true }},
                    { 'r',  function() telescope.registers(ivy) end,                 { exit = true }},
                    { 's',  function() telescope.git_status(ivy) end,                { exit = true }},
                    { 't',  function() telescope.colorscheme(ivy) end,               { exit = true }},
                    { 'z',  function() telescope.git_stash(ivy) end,                 { exit = true }},
                    { 'lc', function() telescope.lsp_incoming_calls(ivy) end,        { exit = true }},
                    { 'lC', function() telescope.lsp_outgoing_calls(ivy) end,        { exit = true }},
                    { 'ld', function() telescope.lsp_definitions(ivy) end,           { exit = true }},
                    { 'li', function() telescope.lsp_implementations(ivy) end,       { exit = true }},
                    { 'lr', function() telescope.lsp_references(ivy) end,            { exit = true }},
                    { 'ls', function() telescope.lsp_document_symbols(ivy) end,      { exit = true }},
                    { 'lS', function() telescope.lsp_workspace_symbols(ivy) end,     { exit = true }},
                    { 'lt', function() telescope.lsp_type_definitions(ivy) end,      { exit = true }},
                    { 'll', function() telescope.diagnostics(ivy) end,               { exit = true }},
                    { 'q',  nil,                                                     { exit = true }},
                }
            })

            local octo_hydra = hydra({
                name  = 'Octo',
                mode  = 'n',
                body  = '<leader>o',
                hint  = octo_hint,
                config = {
                    hint           = hint_options,
                    invoke_on_body = true,
                },
                heads = {
                    { 'g',  function() octo.gists(ivy) end,  { exit = true }},
                    { 'i',  function() octo.issues(ivy) end, { exit = true }},
                    { 'p',  function() octo.prs(ivy) end,    { exit = true }},
                    { 'r',  function() octo.repos(ivy) end,  { exit = true }},
                    { 's',  function() octo.search(ivy) end, { exit = true }},
                    { 'q',  nil,                             { exit = true }},
                }
            })

            hydra({
                name   = 'Hydra',
                mode   = 'n',
                body   = '<leader>h',
                hint   = hydra_hint,
                config = {
                    hint           = hint_options,
                    invoke_on_body = true,
                },
                heads = {
                    { 'f', function() fzf_hydra:activate() end,    { exit = true }},
                    { 'o', function() octo_hydra:activate() end,   { exit = true }},
                    { 'b', function() buffer_hydra:activate() end, { exit = true }},
                    { 'g', function() git_hydra:activate() end,    { exit = true }},
                    { 'l', function() lsp_hydra:activate() end,    { exit = true }},
                    { 'o', function() octo_hydra:activate() end,   { exit = true }},
                    { 'r', function() rust_hydra:activate() end,   { exit = true }},
                    { 't', function() tab_hydra:activate() end,    { exit = true }},
                    { 'v', function() vim_hydra:activate() end,    { exit = true }},
                    { 'w', function() window_hydra:activate() end, { exit = true }},
                    { 'q', nil,                                    { exit = true }},
                }
            })
        end
    }
end
