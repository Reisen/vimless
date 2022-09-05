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
                ^ _h_: Move Left          _H_: Arrange Left
                ^ _j_: Move Down          _J_: Arrange Down
                ^ _k_: Move Up            _K_: Arrange Up
                ^ _l_: Move Right         _L_: Arrange Right

                ^ _s_: Split Horizontal   _v_: Split Vertical ^
                ^ _c_: Close Window
                ^ _x_: Swap Window

                ^ _T_: Move to Tab
                ^ _q_: Quit ]]

            -- Tab Related Hints
            local tab_hint = p.dedent [[
                ^ _h_: Prev Tab
                ^ _l_: Next Tab

                ^ _c_: Close Tab
                ^ _n_: New Empty Tab ^
                ^ _q_: Quit ]]

            -- Buffer Related Hints
            local buffer_hint = p.dedent [[
                ^ _1_: First Buffer   _9_: Last Buffer ^
                ^ _h_: Prev Buffer
                ^ _l_: Next Buffer

                ^ _d_: Delete Focus Buffer
                ^ _o_: Delete Other Buffers
                ^ _q_: Quit ]]

            -- Git Related Hints
            local git_hint = p.dedent [[
                ^ _p_: Prev Hunk
                ^ _n_: Next Hunk
                ^ _s_: Stage Hunk       _S_: Stage File
                ^ _r_: Reset Hunk       _R_: Reset File
                ^ _u_: Undo Stage

                ^ _b_: Blame            _B_: Blame Line
                ^ _d_: Diff Highlight   _D_: Diff Highlight Line ^
                ^ _v_: Diff File        _V_: Diff Repository

                ^ _e_: Git Edit View
                ^ _l_: Git Log View
                ^ _q_: Quit ]]

            -- Rust Related Hints
            local rust_hint = p.dedent [[
                ^ _u_:  Move Item Up        _d_:  Move Item Down ^

                ^ _co_: Goto Cargo.toml
                ^ _ci_: Show Crate Info
                ^ _cu_: Update Crate        _cU_: Upgrade Crate

                ^ _a_:  Rust Code Actions
                ^ _e_:  Expand Macro
                ^ _f_:  Format Code
                ^ _s_:  Goto Super Module
                ^ _t_:  Cargo Tree
                ^ _q_:  Quit ]]

            -- Jump Related Hints
            local jump_hint = p.dedent [[
                ^ _j_:  Reach Buffer
                ^ _m_:  Reach Marks
                ^ _c_:  Reach Colorschemes

                ^ _hm_: Harpoon Mark
                ^ _hj_: Harpoon Jump

                ^ _t_:  Jump to Type
                ^ _d_:  Jump to Definition
                ^ _i_:  Jump to Implementation
                ^ _p_:  Prev Diagnostic          _n_:  Next Diagnostic ^

                ^ _l_:  List Diagnostics
                ^ _r_:  List References

                ^ _q_:  Quit ]]

            -- Vim Hints
            local vim_hint = p.dedent [[
                ^ _pc_: Compile Plugins
                ^ _ps_: Sync Plugins
                ^ _p?_: Plugin Info

                ^ _t_:  Toggle Trouble

                ^ _q_: Quit ]]

            -- LSP Hints
            local lsp_hint = p.dedent [[
                ^ _p_: Prev Diagnostic       _n_: Next Diagnostic

                ^ _a_: Code Action
                ^ _d_: Goto Definition       _D_: Goto Declaration
                ^ _f_: Format File
                ^ _i_: Goto Implementation
                ^ _K_: Documentation
                ^ _l_: Diagnostics Loclist
                ^ _r_: References            _R_: Rename
                ^ _t_: Type Definition

                ^ _q_: Quit ]]

            -- FZF Hints
            local fzf_hint = p.dedent [[
                ^ _*_:  Grep Word
                ^ _a_:  Buffer Lines
                ^ _g_:  Grep

                ^ _b_:  Git Branches
                ^ _c_:  Git Commits           _C_:  Git File Commits
                ^ _f_:  Git Files
                ^ _z_:  Git Stash

                ^ _lr_: LSP References
                ^ _li_: LSP Implementations
                ^ _ld_: LSP Definitions

                ^ _q_: Quit ]]

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
                    { 'u',  function() vim.cmd 'RustMoveItemUp' end,   {}},
                    { 'd',  function() vim.cmd 'RustMoveItemDown' end, {}},

                    { 'a',  function() vim.cmd 'RustCodeAction' end,          { exit = true }},
                    { 'e',  function() vim.cmd 'RustExpandMacro' end,         { exit = true }},
                    { 's',  function() vim.cmd 'RustParentModule' end,        { exit = true }},
                    { 't',  function() vim.cmd 'Cargo tree' end,              { exit = true }},
                    { 'f',  function() vim.cmd 'RustFmt' end,                 { exit = true }},

                    { 'co', function() vim.cmd 'RustOpenCargo' end,           { exit = true }},
                    { 'cu', function() require('crates').update_crate() end,  { exit = true }},
                    { 'cU', function() require('crates').upgrade_crate() end, { exit = true }},
                    { 'ci', function() require('crates').show_popup() end,    { exit = true }},

                    { 'q', nil,                                               { exit = true }},
                },
            })

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
                    { 'j',  c.cmd('ReachOpen buffers'),            { exit = true }},
                    { 'm',  c.cmd('ReachOpen marks'),              { exit = true }},
                    { 'c',  c.cmd('ReachOpen colorschemes'),       { exit = true }},
                    { 'd',  vim.lsp.buf.definition,                { exit = true }},
                    { 'i',  vim.lsp.buf.implementation,            { exit = true }},
                    { 'n',  vim.diagnostic.goto_next,              { exit = true }},
                    { 'p',  vim.diagnostic.goto_prev,              { exit = true }},
                    { 't',  vim.lsp.buf.type_definition,           { exit = true }},
                    { 'l',  vim.diagnostic.setloclist,             { exit = true }},
                    { 'r',  vim.lsp.buf.references,                { exit = true }},

                    { 'hm', require'harpoon.mark'.add_file,        { exit = true }},
                    { 'hj', require'harpoon.ui'.toggle_quick_menu, { exit = true }},

                    { 'q', nil,                                    { exit = true }},
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
                    { '*',  c.cmd('FzfLua grep_cword'),          { exit = true }},
                    { 'g',  c.cmd('FzfLua grep'),                { exit = true }},
                    { 'a',  c.cmd('FzfLua blines'),              { exit = true }},
                    { 'b',  c.cmd('FzfLua git_branches'),        { exit = true }},
                    { 'c',  c.cmd('FzfLua git_commits'),         { exit = true }},
                    { 'C',  c.cmd('FzfLua git_bcommits'),        { exit = true }},
                    { 'f',  c.cmd('FzfLua git_files'),           { exit = true }},
                    { 'z',  c.cmd('FzfLua git_stash'),           { exit = true }},
                    { 'lr', c.cmd('FzfLua lsp_references'),      { exit = true }},
                    { 'li', c.cmd('FzfLua lsp_implementations'), { exit = true }},
                    { 'ld', c.cmd('FzfLua lsp_definitions'),     { exit = true }},
                    { 'q',  nil,                                 { exit = true }},
                }
            })
        end
    }
end
