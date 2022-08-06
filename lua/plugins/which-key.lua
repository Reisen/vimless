return function(use)
    use { 'folke/which-key.nvim',
        config = function()
            local which_key  = require('which-key')
            local gitsigns   = function() return package.loaded.gitsigns end
            local theme      = 'require("telescope.themes").get_dropdown({})'
            local no_preview = 'require("telescope.themes").get_dropdown({preview=false})'

            -- Register Custom Keymapping.
            which_key.register({
                -- Navigation Binds.
                ['<Space>'] = {':wincmd p<CR>',           'Return to Previous Window'},
                j           = { ':ReachOpen buffers<CR>', 'Reach Buffers' },
                m           = { ':ReachOpen marks<CR>',   'Reach Marks' },

                c = {
                    name = 'Comment',
                    c = { ':normal gcc<CR>',  'Comment Line' },
                    b = { ':normal gca{<CR>', 'Comment Block' },
                },

                e = {
                    e = { ':1TermExec   direction=horizontal size=25 go_back=0 cmd="alot"<CR>', 'Email' },
                    h = { ':1TermExec   direction=horizontal size=25 go_back=0 cmd="dijo"<CR>', 'Dijo' },
                    j = { ':1ToggleTerm direction=horizontal size=25<CR>',                      'Open Bottom Terminal' },
                },

                g = {
                    name = 'Git',
                    b = { ':G blame<CR>',                                       'Blame' },
                    D = { function() gitsigns().diffthis('~') end,              'Diff Line' },
                    d = { ':Gitsigns toggle_linehl<CR>',                        'Diff Highlight' },
                    e = { ':Gedit:<CR>',                                        'Edit' },
                    l = { ':G log --oneline<CR>',                               'Log' },
                    n = { ':Gitsigns next_hunk<CR>',                            'Next Hunk' },
                    p = { ':Gitsigns prev_hunk<CR>',                            'Previous Hunk' },
                    R = { function() gitsigns().reset_buffer() end,             'Reset Buffer' },
                    r = { ':Gitsigns reset_hunk<CR>',                           'Reset Hunk' },
                    S = { function() gitsigns().stage_buffer() end,             'Stage Buffer' },
                    s = { ':Gitsigns stage_hunk<CR>',                           'Stage Hunk' },
                    u = { function() gitsigns().undo_stage_hunk() end,          'Undo Stage Hunk' },
                    w = { function() gitsigns().blame_line { full = true } end, 'Blame Line' },
                },

                p = {
                    name = 'Plugin Specific Bindings',
                    c = { ':lua require("cryptoprice").toggle()<CR>', 'Crypto Prices' },
                    g = { ':Goyo<CR>',                                'Goyo' },
                    d = {
                        name = 'Diffview',
                        o    = { ':DiffviewOpen<CR>',          'Show Repository Diff' },
                        h    = { ':DiffviewFileHistory %<CR>', 'Show File History   ' },
                    },
                    h = {
                        name = 'Harpoon',
                        a    = { ':lua require("harpoon.mark").add_file()<CR>',        'Add File' },
                        l    = { ':lua require("harpoon.ui").toggle_quick_menu()<CR>', 'List Files' },
                    },
                    p = {
                        name  = 'Packer',
                        c     = { ':PackerCompile<CR>', 'Compile Config' },
                        s     = { ':PackerSync<CR>',    'Sync Packer' },
                        ["?"] = { ':PackerStatus<CR>',  'Status' },
                    },
                    r = {
                        name = 'Rust.vim',
                        a    = { ':RustCodeAction<CR>',   'Code Action' },
                        c    = { ':RustOpenCargo<CR>',    'Open Cargo.toml' },
                        d    = { ':RustMoveItemDown<CR>', 'Move Item Down' },
                        e    = { ':RustExpandMacro<CR>',  'Expand Macro' },
                        p    = { ':RustParentModule<CR>', 'Parent Module' },
                        u    = { ':RustMoveItemUp<CR>',   'Move Item Up' },
                    },
                    s = {
                        name = 'Symbol Outliner',
                        t    = { ':SymbolsOutline<CR>', 'Toggle Outliner' },
                    },
                    t = {
                        name = 'Trouble',
                        t    = { ':TroubleToggle<CR>',                       'Toggle Trouble' },
                        d    = { ':TroubleToggle document_diagnostics<CR>',  'Document Diagnostics' },
                        w    = { ':TroubleToggle workspace_diagnostics<CR>', 'Workspace Diagnostics' },
                    },
                },

                f = {
                    name  = 'Telescope',
                    ["*"] = { ':lua require("telescope.builtin").grep_string(' .. theme .. ')<CR>',       'Grep Directory' },
                    a     = { ':lua require("telescope.builtin").autocommands(' .. no_preview .. ')<CR>', 'Vim Autocommands' },
                    b     = { ':lua require("telescope.builtin").buffers(' .. theme .. ')<CR>',           'Vim Buffers' },
                    B     = { ':lua require("telescope.builtin").git_branches()<CR>',                     'Git Branches' },
                    C     = { ':lua require("telescope.builtin").git_commits()<CR>',                      'Git Commits' },
                    F     = { ':lua require("telescope.builtin").git_bcommits()<CR>',                     'Git File History' },
                    f     = { ':lua require("telescope.builtin").git_files(' .. theme .. ')<CR>',         'Find Files' },
                    h     = { ':Telescope harpoon marks<CR>',                                             'Harpoon Marks' },
                    k     = { ':lua require("telescope.builtin").keymaps()<CR>',                          'Vim Keymaps' },
                    m     = { ':lua require("telescope.builtin").man_pages()<CR>',                        'Man Pages' },
                    q     = { ':lua require("telescope.builtin").live_grep()<CR>',                        'Grep Live' },
                    S     = { ':lua require("telescope.builtin").git_status()<CR>',                       'Git Status' },
                    s     = { ':Telescope session-lens search_session<CR>',                               'Sessions' },
                    Z     = { ':lua require("telescope.builtin").git_stash()<CR>',                        'Git Stashes' },
                    l     = {
                        name = 'Telescope LSP',
                        r    = { ':lua require("telescope.builtin").lsp_references()<CR>',        'References' },
                        s    = { ':lua require("telescope.builtin").lsp_document_symbols()<CR>',  'Document Symbols' },
                        w    = { ':lua require("telescope.builtin").lsp_workspace_symbols()<CR>', 'Workspace Symbols' },
                        e    = { ':lua require("telescope.builtin").diagnostics()<CR>',           'Errors' },
                        i    = { ':lua require("telescope.builtin").lsp_implementations()<CR>',   'Implementations' },
                        d    = { ':lua require("telescope.builtin").lsp_definitions()<CR>',       'Definitions' },
                        t    = { ':lua require("telescope.builtin").lsp_type_definitions()<CR>',  'Type Definitions' },
                    }
                },

                l = {
                    name = 'LSP',
                    D    = { ':lua vim.lsp.buf.declaration()<CR>', 'Declaration' },
                    K    = { ':lua vim.lsp.buf.hover()<CR>', 'Documentation' },
                    R    = { ':lua vim.lsp.buf.rename()<CR>', 'Rename' },
                    a    = { ':lua vim.lsp.buf.code_action()<CR>', 'Code Action' },
                    d    = { ':lua vim.lsp.buf.definition()<CR>', 'Definition' },
                    f    = { ':lua vim.lsp.buf.format({async=true})<CR>', 'Format File' },
                    i    = { ':lua vim.lsp.buf.implementation()<CR>', 'Implementation' },
                    l    = { ':lua vim.diagnostic.setloclist()<CR>', 'Locations' },
                    n    = { ':lua vim.diagnostic.goto_next()<CR>', 'Next Diagnostic' },
                    p    = { ':lua vim.diagnostic.goto_prev()<CR>', 'Prev Diagnostic' },
                    r    = { ':lua vim.lsp.buf.references()<CR>', 'References' },
                    t    = { ':lua vim.lsp.buf.type_definition()<CR>', 'Type Definition' },
                },

                -- Window Bindings
                w = (function()
                    local symbols = 'hjklHJKLsvxcT='
                    local binds   = { name = 'Window Bindings', }
                    for i = 1, #symbols do
                        local v  = symbols:sub(i, i)
                        binds[v] = { ':wincmd ' .. v .. '<CR>', 'CTRL-W_' .. v }
                    end
                    return binds
                end)(),

                -- Tab Bindings
                t = (function()
                    local symbols = 'ecnp'
                    local binds   = { name = 'Tab Bindings', }
                    for i = 1, #symbols do
                        local v  = symbols:sub(i, i)
                        binds[v] = { ':tab' .. v .. '<CR>', 'CTRL-T_' .. v }
                    end
                    return binds
                end)(),

                -- Buffer Bindings
                b = (function()
                    local symbols = 'fldnp'
                    local binds   = { name = 'Buffer Bindings', }
                    for i = 1, #symbols do
                        local v  = symbols:sub(i, i)
                        binds[v] = { ':b' .. v .. '<CR>', 'CTRL-T_' .. v }
                    end

                    -- Delete all buffers but current.
                    binds['o'] = { ':%bd|e#|bd#<CR>', 'Only Buffer' }

                    return binds
                end)(),

                -- Vim Bindings
                v = {
                    name = 'Vim Bindings',
                    v    = { ':e $HOME/.config/nvim/init.vim<CR>', '.vimrc' },
                    c    = { function() vim.o.background = vim.o.background == 'light' and 'dark' or 'light' end, 'Toggle Light/Dark' }
                },

                -- Quicklist Bindings
                q = {
                    name = 'Quicklist Bindings',
                    w    = { ':lw<CR>', 'Open Location List' },
                    p    = { ':lp<CR>', 'Next Location Item' },
                    n    = { ':lne}<CR>', 'Prev Location Item' },
                },
            }, { prefix = '<Leader>' })

            -- Configure Whichkey Design.
            which_key.setup {
                window = {
                    position = 'top',
                },

                layout = {
                    align   = "center",
                    height  = { min = 40, max = 40 },
                    spacing = 8,
                    width   = { min = 30, max = 40 },
                },
            }
        end
    }
end
