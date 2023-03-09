---@diagnostic disable: need-check-nil

-- Hydra's are small hint windows that provide quick access to common actions.
-- We provide here a default set of Hydra definitions that make it easy to
-- navigate all the <Space> bound actions this vim configuration provides.
return function(use)
    use {
        'anuvyklack/hydra.nvim',
        requires = {
            'lewis6991/gitsigns.nvim',
            'nvim-lua/plenary.nvim',
            'saecki/crates.nvim',
        },
        config = function()
            local p           = require 'plenary.strings'
            local hydra       = require 'hydra'
            local c           = require 'hydra.keymap-util'
            local gitsigns    = require 'gitsigns'

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

            -- Window Related Hints.
            local window_hint = p.dedent [[
                ^ Navigation
                ^ _h_: Move Left          
                ^ _j_: Move Down          
                ^ _k_: Move Up            
                ^ _l_: Move Right         

                ^ Arrange & Split
                ^ _H_: Arrange Left
                ^ _J_: Arrange Down
                ^ _K_: Arrange Up
                ^ _L_: Arrange Right
                ^ _s_: Split Horizontal ^
                ^ _v_: Split Vertical

                ^ General
                ^ _T_: Move to Tab
                ^ _c_: Close Window
                ^ _x_: Swap Window
                ^ _q_: Quit ]]

            -- Tab Related Hints
            local tab_hint = p.dedent [[
                ^ Navigation
                ^ _h_: Prev Tab
                ^ _l_: Next Tab

                ^ General
                ^ _c_: Close Tab
                ^ _n_: New Empty Tab ^
                ^ _q_: Quit ]]

            -- Buffer Related Hints
            local buffer_hint = p.dedent [[
                ^ Navigation
                ^ _1_: First Buffer
                ^ _9_: Last Buffer
                ^ _h_: Prev Buffer
                ^ _l_: Next Buffer

                ^ General
                ^ _d_: Delete Focus Buffer
                ^ _o_: Delete Other Buffers ^
                ^ _q_: Quit ]]

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
                ^ _a_: Rust Code Actions
                ^ _e_: Expand Macro
                ^ _f_: Format Code
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
                ^ _t_: Cargo Tree
                ^ _q_: Quit ]]

            -- Vim Hints
            local vim_hint = p.dedent [[
                ^ Packer
                ^ _pc_: Compile Plugins ^
                ^ _ps_: Sync Plugins
                ^ _p?_: Plugin Info

                ^ General
                ^ _m_:  Toggle Minimap
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
                ^ _j_:  Jump
                ^ _*_:  Grep Word
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
                position = 'bottom',
                border   = 'solid',
                offset   = 1,
            }

            -- Initialize Hydras
            local window_hydra = hydra({
                name   = 'Window Management',
                mode   = 'n',
                body   = '<leader>w',
                hint   = window_hint,
                config = {
                    hint           = hint_options,
                    invoke_on_body = true,
                },
                heads  = {
                    {'c', c.cmd('wincmd c'), {}},
                    {'h', c.cmd('wincmd h'), {}},
                    {'H', c.cmd('wincmd H'), {}},
                    {'j', c.cmd('wincmd j'), {}},
                    {'J', c.cmd('wincmd J'), {}},
                    {'k', c.cmd('wincmd k'), {}},
                    {'K', c.cmd('wincmd K'), {}},
                    {'l', c.cmd('wincmd l'), {}},
                    {'L', c.cmd('wincmd L'), {}},
                    {'s', c.cmd('wincmd s'), {}},
                    {'v', c.cmd('wincmd v'), {}},
                    {'x', c.cmd('wincmd x'), {}},
                    {'T', c.cmd('wincmd T'), { exit = true }},
                    {'q', nil,               { exit = true }},
                },
            })

            local tab_hydra = hydra({
                name   = 'Tab Management',
                mode   = 'n',
                body   = '<leader>t',
                hint   = tab_hint,
                config = {
                    hint           = hint_options,
                    invoke_on_body = true,
                },
                heads  = {
                    {'h', c.cmd('tabp'), {}},
                    {'l', c.cmd('tabn'), {}},
                    {'n', c.cmd('tabe'), { exit = true }},
                    {'c', c.cmd('tabc'), { exit = true }},
                    {'q', nil,           { exit = true }},
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
                    { 'k',  c.cmd 'RustMoveItemUp',                   { exit = true }},
                    { 'j',  c.cmd 'RustMoveItemDown',                 { exit = true }},

                    { 'a',  c.cmd 'RustCodeAction',                   { exit = true }},
                    { 'e',  c.cmd 'RustExpandMacro',                  { exit = true }},
                    { 's',  c.cmd 'RustParentModule',                 { exit = true }},
                    { 't',  c.cmd 'Cargo tree',                       { exit = true }},
                    { 'f',  c.cmd 'RustFmt',                          { exit = true }},

                    { 'c', c.cmd 'RustOpenCargo',                     { exit = true }},
                    { 'u', require('crates').update_crate,            { exit = true }},
                    { 'U', require('crates').upgrade_crate,           { exit = true }},
                    { 'i', require('crates').show_popup,              { exit = true }},
                    { 'd', require('crates').show_dependencies_popup, { exit = true }},
                    { 'o', require('crates').show_features_popup,     { exit = true }},
                    { 'v', require('crates').show_versions_popup,     { exit = true }},

                    { 'q', nil,                                       { exit = true }},
                },
            })

            local vim_hydra = hydra({
                name   = 'VIM',
                mode   = 'n',
                body   = '<leader>v',
                hint   = vim_hint,
                config = {
                    hint           = hint_options,
                    invoke_on_body = true,
                },
                heads  = {
                    { 'pc', c.cmd('PackerCompile'),   { exit = true }},
                    { 'ps', c.cmd('PackerSync'),      { exit = true }},
                    { 'p?', c.cmd('PackerStatus'),    { exit = true }},
                    { 'm',  require'mini.map'.toggle, { exit = true }},
                    { 't',  c.cmd('TroubleToggle'),   { exit = true }},
                    { 'q',  nil,                      { exit = true }},
                }
            })

            local lsp_hydra = hydra({
                name   = 'LSP',
                mode   = 'n',
                body   = '<leader>l',
                hint   = lsp_hint,
                color  = 'pink',
                config = {
                    hint           = hint_options,
                    invoke_on_body = true,
                    on_key         = function() vim.wait(50) end,
                },
                heads  = {
                    { 'n', vim.diagnostic.goto_next,    { exit = true }},
                    { 'p', vim.diagnostic.goto_prev,    { exit = true }},

                    { 'D', vim.lsp.buf.declaration,     { exit = true }},
                    { 'K', vim.lsp.buf.hover,           { exit = true }},
                    { 'R', vim.lsp.buf.rename,          { exit = true }},
                    { 'a', vim.lsp.buf.code_action,     { exit = true }},
                    { 'd', vim.lsp.buf.definition,      { exit = true }},
                    { 'f', vim.lsp.buf.formatting,      { exit = true }},
                    { 'i', vim.lsp.buf.implementation,  { exit = true }},
                    { 'l', vim.diagnostic.setloclist,   { exit = true }},
                    { 'r', vim.lsp.buf.references,      { exit = true }},
                    { 't', vim.lsp.buf.type_definition, { exit = true }},
                    { 'q', nil,                         { exit = true }},
                }
            })

            -- Create Telescope and Theme objects for use in the Hydra
            local telescope = require'telescope.builtin'

            local ivy = require'telescope.themes'.get_dropdown {
                border        = true,
                layout_config = { height = 16 },
                borderchars   = {
                    prompt  = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
                    results = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
                    preview = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
                },
            }

            local cursor = require'telescope.themes'.get_cursor {
                border        = true,
                layout_config = { height = 16 },
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
                layout_config         = { height = 16 },
                borderchars           = {
                    prompt  = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
                    results = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
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
