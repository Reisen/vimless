local keymap = {
}

return function(use)
    use { 'folke/which-key.nvim',
        config = function()
            local which_key = require('which-key')
            local gitsigns  = function() return package.loaded.gitsigns end

            -- Register Custom Keymapping.
            which_key.register({
                j = { ':ReachOpen buffers<CR>', 'Reach Buffers' },
                m = { ':ReachOpen marks<CR>',   'Reach Marks' },
                c = {
                    name = 'Comment',
                    c = { ':normal gcc<CR>',  'Comment Line' },
                    b = { ':normal gca{<CR>', 'Comment Block' },
                },

                g = {
                    name = 'Git',
                    b = { ':G blame<CR>',                                  'Blame' },
                    e = { ':Gedit:<CR>',                                   'Edit' },
                    d = { ':Gitsigns toggle_linehl<CR>',                   'Diff Highlight' },
                    l = { ':G log --oneline<CR>',                          'Log' },
                    n = { ':Gitsigns next_hunk<CR>',                       'Next Hunk' },
                    p = { ':Gitsigns prev_hunk<CR>',                       'Previous Hunk' },
                    s = { ':G status<CR>',                                 'Status' },
                    w = { function() gitsigns().blame_line{full=true} end, 'Blame Line' },
                    h = {
                        name = 'Git Hunk',
                        R = { function() gitsigns().reset_buffer() end,    'Reset Buffer' },
                        S = { function() gitsigns().stage_buffer() end,    'Stage Buffer' },
                        d = { function() gitsigns().diffthis('~') end,     'Diff Line' },
                        p = { function() gitsigns().preview_hunk() end,    'Preview Hunk' },
                        r = { ':Gitsigns reset_hunk<CR>',                  'Reset Hunk' },
                        s = { ':Gitsigns stage_hunk<CR>',                  'Stage Hunk' },
                        u = { function() gitsigns().undo_stage_hunk() end, 'Undo Stage Hunk' },
                    },
                },

                h = {
                    name = 'Harpoon',
                    a = { ':lua require("harpoon.mark").add_file()<CR>',        'Add File' },
                    l = { ':lua require("harpoon.ui").toggle_quick_menu()<CR>', 'List Files' },
                },

                p = {
                    name = 'Plugin Specific Bindings',
                    c = { ':lua require("cryptoprice").toggle()<CR>', 'Crypto Prices' },
                    g = { ':Goyo<CR>', 'Goyo' },
                    d = {
                        name = 'Diffview',
                        o = { ':DiffviewOpen<CR>',        'Show Repository Diff' },
                        h = { ':DiffviewFileHistory %<CR>', 'Show File History   ' },
                    },
                    p = {
                        name  = 'Packer',
                        c     = { ':PackerCompile<CR>', 'Compile Config' },
                        s     = { ':PackerSync<CR>',    'Sync Packer' },
                        ["?"] = { ':PackerStatus<CR>',  'Status' },
                    },
                    t = {
                        name = 'Trouble',
                        t = { ':TroubleToggle<CR>',                       'Toggle Trouble' },
                        d = { ':TroubleToggle document_diagnostics<CR>',  'Document Diagnostics' },
                        w = { ':TroubleToggle workspace_diagnostics<CR>', 'Workspace Diagnostics' },
                    },
                    s = {
                        name = 'Symbol Outliner',
                        t = { ':SymbolsOutline<CR>', 'Toggle Outliner' },
                    }
                },

                f = {
                    name  = 'Telescope',
                    ["*"] = { ':lua require("telescope.builtin").grep_string(require("telescope.themes").get_dropdown({}))<CR>', 'Grep Directory' },
                    a     = { ':lua require("telescope.builtin").autocommands()<CR>',                                            'Vim Autocommands' },
                    b     = { ':lua require("telescope.builtin").buffers()<CR>',                                                 'Vim Buffers' },
                    f     = { ':lua require("telescope.builtin").git_files()<CR>',                                               'Find Files' },
                    h     = { ':Telescope harpoon marks<CR>',                                                                    'Harpoon Marks' },
                    k     = { ':lua require("telescope.builtin").keymaps()<CR>',                                                 'Vim Keymaps' },
                    m     = { ':lua require("telescope.builtin").man_pages()<CR>',                                               'Man Pages' },
                    q     = { ':lua require("telescope.builtin").live_grep()<CR>',                                               'Grep Live' },
                    r     = { ':lua require("telescope.builtin").registers()<CR>',                                               'Vim Registers' },
                    s     = { ':Telescope session-lens search_session<CR>',                                                      'Sessions' },
                    g     = {
                        name = 'Telescope Git',
                        b    = { ':lua require("telescope.builtin").git_branches()<CR>', 'Branches' },
                        c    = { ':lua require("telescope.builtin").git_commits()<CR>',  'Commits' },
                        f    = { ':lua require("telescope.builtin").git_bcommits()<CR>', 'File Commits' },
                        s    = { ':lua require("telescope.builtin").git_status()<CR>',   'Status' },
                        z    = { ':lua require("telescope.builtin").git_stash()<CR>',    'Stash' },
                    },
                    l = {
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

                r = {
                    name = 'Rust.vim',
                    a    = { ':RustCodeAction<CR>',   'Code Action' },
                    c    = { ':RustOpenCargo<CR>',    'Open Cargo.toml' },
                    d    = { ':RustMoveItemDown<CR>', 'Move Item Down' },
                    e    = { ':RustExpandMacro<CR>',  'Expand Macro' },
                    p    = { ':RustParentModule<CR>', 'Parent Module' },
                    u    = { ':RustMoveItemUp<CR>',   'Move Item Up' },
                },

                l = {
                    name = 'LSP',
                    D    = { ':lua vim.lsp.buf.declaration()<CR>',     'Declaration' },
                    K    = { ':lua vim.lsp.buf.hover()<CR>',           'Documentation' },
                    R    = { ':lua vim.lsp.buf.rename()<CR>',          'Rename' },
                    a    = { ':lua vim.lsp.buf.code_action()<CR>',     'Code Action' },
                    d    = { ':lua vim.lsp.buf.definition()<CR>',      'Definition' },
                    f    = { ':lua vim.lsp.buf.formatting()<CR>',      'Format File' },
                    i    = { ':lua vim.lsp.buf.implementation()<CR>',  'Implementation' },
                    l    = { ':lua vim.diagnostic.setloclist()<CR>',   'Locations' },
                    n    = { ':lua vim.diagnostic.goto_next()<CR>',    'Next Diagnostic' },
                    p    = { ':lua vim.diagnostic.goto_prev()<CR>',    'Prev Diagnostic' },
                    r    = { ':lua vim.lsp.buf.references()<CR>',      'References' },
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

                -- Vim Bindings
                v = {
                    name = 'Vim Bindings',
                    v    = { ':e $HOME/.config/nvim/init.vim<CR>', '.vimrc' },
                    c    = { function()
                        vim.o.background = vim.o.background == 'light' and 'dark' or 'light'
                    end, 'Toggle Light/Dark' }
                },

                -- Quicklist Bindings
                q = {
                    name = 'Quicklist Bindings',
                    w    = { ':lw<CR>',   'Open Location List' },
                    p    = { ':lp<CR>',   'Next Location Item' },
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
