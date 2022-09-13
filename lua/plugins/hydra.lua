-- Hydra's are small hint windows that provide quick access to common actions.
-- We provide here a default set of Hydra definitions that make it easy to
-- navigate all the <Space> bound actions this vim configuration provides.
return function(use)
    use {
        'anuvyklack/hydra.nvim',
        config = function()
            local p           = require('plenary.strings')
            local hydra       = require 'hydra'
            local c           = require 'hydra.keymap-util'
            local gitsigns    = require 'gitsigns'

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

            -- Jump Related Hints
            local jump_hint = p.dedent [[
                ^ Reach
                ^ _j_: Buffer
                ^ _m_: Marks
                ^ _c_: Colorschemes ^

                ^ Harpoon
                ^ _h_: Harpoon Jump
                ^ _._: Harpoon Mark

                ^ Navigation
                ^ _l_: Last Buffer
                ^ _q_: Quit ]]

            -- Vim Hints
            local vim_hint = p.dedent [[
                ^ Packer
                ^ _pc_: Compile Plugins ^
                ^ _ps_: Sync Plugins
                ^ _p?_: Plugin Info

                ^ General
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
                ^ _a_:  Buffer Lines
                ^ _g_:  Grep

                ^ Git Related
                ^ _b_:  Git Branches
                ^ _c_:  Git Commits (_C_: File) ^
                ^ _f_:  Git Files
                ^ _z_:  Git Stash

                ^ LSP
                ^ _ld_: LSP Definitions
                ^ _lD_: LSP Document Symbols
                ^ _lr_: LSP References         
                ^ _lW_: LSP Workspace Symbols
                ^ _li_: LSP Implementations
                ^ _lt_: LSP Type Definitions
                ^ _lc_: LSP Incoming Calls
                ^ _lC_: LSP Outgoing Calls

                ^ General
                ^ _o_:  Vim Options
                ^ _r_:  Vim Registers
                ^ _q_:  Quit ]]

            -- Hint Options that are shared by all Hydras.
            local hint_options = {
                position = 'bottom',
                border   = 'solid',
                offset   = 1,
            }

            -- Initialize Hydras
            hydra({
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

            hydra({
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

            hydra({
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

            hydra({
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
                    { 'R', gitsigns.reset_buffer,                        {}},
                    { 'S', gitsigns.stage_buffer,                        {}},
                    { 'u', gitsigns.undo_stage_hunk,                     {}},

                    { 'B', function() gitsigns.blame_line { full = true } end, { exit = true }},
                    { 'b', function() vim.cmd 'G blame' end,                   { exit = true }},
                    { 'd', function() vim.cmd 'Gitsigns toggle_linehl' end,    { exit = true }},
                    { 'D', function() vim.cmd 'Gitsigns toggle_numhl' end,     { exit = true }},
                    { 'e', function() vim.cmd 'Gedit:' end,                    { exit = true }},
                    { 'l', function() vim.cmd 'G log --oneline' end,           { exit = true }},
                    { 'v', function() vim.cmd 'DiffviewFileHistory %' end,     { exit = true }},
                    { 'V', function() vim.cmd 'DiffviewOpen' end,              { exit = true }},
                    { 'q', nil,                                                { exit = true }},
                },
            })

            hydra({
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

            -- Configure Reach for Buffer Jumping
            local reach_options = {
                handle       = 'auto',
                show_current = true,
                sort         = function(a, b)
                    return vim.fn.getbufinfo(a)[1].lastused > vim.fn.getbufinfo(b)[1].lastused
                end,
            }

            -- Function to swap to the last buffer for this window.
            local function swap_to_last_buffer()
                local last_buffer = vim.fn.bufnr('#')
                if last_buffer ~= -1 then
                    vim.cmd('buffer ' .. last_buffer)
                end
            end

            hydra({
                name   = 'Jump',
                mode   = 'n',
                body   = '<leader>j',
                hint   = jump_hint,
                config = {
                    hint           = hint_options,
                    invoke_on_body = true,
                },
                heads  = {
                    { 'j', function() require'reach'.buffers(reach_options) end, { exit = true }},
                    { 'm', c.cmd('ReachOpen marks'),                             { exit = true }},
                    { 'c', c.cmd('ReachOpen colorschemes'),                      { exit = true }},
                    { 'h', require'harpoon.ui'.toggle_quick_menu,                 { exit = true }},
                    { '.', require'harpoon.mark'.add_file,                        { exit = true }},
                    { 'l', swap_to_last_buffer,                                   { exit = true }},

                    { 'q', nil,                                                   { exit = true }},
                },

            })

            hydra({
                name   = 'VIM',
                mode   = 'n',
                body   = '<leader>v',
                hint   = vim_hint,
                config = {
                    hint           = hint_options,
                    invoke_on_body = true,
                },
                heads  = {
                    { 'pc', c.cmd('PackerCompile'), { exit = true }},
                    { 'ps', c.cmd('PackerSync'),    { exit = true }},
                    { 'p?', c.cmd('PackerStatus'),  { exit = true }},
                    { 't',  c.cmd('TroubleToggle'), { exit = true }},
                    { 'q',  nil,                    { exit = true }},
                }
            })

            hydra({
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
            local ivy       = require'telescope.themes'.get_ivy {
                border      = false,
                borderchars = {
                    prompt  = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
                    results = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
                    preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
                },
            }

            -- Ivy but with sort_mru included in the options.
            local ivy_bufs  = require'telescope.themes'.get_ivy {
                border                = false,
                sort_mru              = true,
                ignore_current_buffer = true,
                borderchars           = {
                    prompt  = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
                    results = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
                    preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
                },
            }

            hydra({
                name  = 'FZF',
                mode  = 'n',
                body  = '<leader>f',
                hint  = fzf_hint,
                config = {
                    hint           = hint_options,
                    invoke_on_body = true,
                },
                heads = {
                    { '*',  function() telescope.grep_string(ivy) end,               { exit = true }},
                    { 'g',  function() telescope.live_grep(ivy) end,                 { exit = true }},
                    { 'o',  function() telescope.vim_options(ivy) end,               { exit = true }},
                    { 'a',  function() telescope.current_buffer_fuzzy_find(ivy) end, { exit = true }},
                    { 'b',  function() telescope.git_branches(ivy) end,              { exit = true }},
                    { 'C',  function() telescope.git_bcommits(ivy) end,              { exit = true }},
                    { 'c',  function() telescope.git_commits(ivy) end,               { exit = true }},
                    { 'f',  function() telescope.git_files(ivy) end,                 { exit = true }},
                    { 'j',  function() telescope.buffers(ivy_bufs) end,              { exit = true }},
                    { 'r',  function() telescope.registers(ivy) end,                 { exit = true }},
                    { 'z',  function() telescope.git_stash(ivy) end,                 { exit = true }},
                    { 'lr', function() telescope.lsp_references(ivy) end,            { exit = true }},
                    { 'li', function() telescope.lsp_implementations(ivy) end,       { exit = true }},
                    { 'ld', function() telescope.lsp_definitions(ivy) end,           { exit = true }},
                    { 'lt', function() telescope.lsp_type_definitions(ivy) end,      { exit = true }},
                    { 'lD', function() telescope.lsp_document_symbols(ivy) end,      { exit = true }},
                    { 'lW', function() telescope.lsp_workspace_symbols(ivy) end,     { exit = true }},
                    { 'lc', function() telescope.lsp_incoming_calls(ivy) end,        { exit = true }},
                    { 'lC', function() telescope.lsp_outgoing_calls(ivy) end,        { exit = true }},
                    { 'q',  nil,                                                     { exit = true }},
                }
            })
        end
    }
end
