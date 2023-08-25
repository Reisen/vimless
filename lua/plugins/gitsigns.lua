return function(config)
    if type(config.plugins.gitsigns) == 'boolean' and not config.plugins.gitsigns then
        return {}
    end

    return {
        'lewis6991/gitsigns.nvim',
        config = function()
            if config.plugins.gitsigns and type(config.plugins.gitsigns) == 'function' then
                config.plugins.gitsigns()
                return
            end

            local opts = {
                numhl                   = true,
                linehl                  = true,
                signcolumn              = true,
                current_line_blame      = false,
                word_diff               = false,
                current_line_blame_opts = {
                    delay         = 100,
                    virt_text_pos = 'right_align',
                },

                signs = {
                    -- Use Unicode medium width pipe drawing char.
                    add          = { text = '│', show_count = false },
                    change       = { text = '│', show_count = false },
                    delete       = { text = '│', show_count = false },
                    topdelete    = { text = '│', show_count = false },
                    changedelete = { text = '│', show_count = false },
                    untracked    = { text = '│', show_count = false },
                },

                count_chars = {} or {
                    [1]   = '1',
                    [2]   = '2',
                    [3]   = '3',
                    [4]   = '4',
                    [5]   = '5',
                    [6]   = '6',
                    [7]   = '7',
                    [8]   = '8',
                    [9]   = '9',
                    ['+'] = '+',
                }
            }

            if config.plugins.gitsigns and type(config.plugins.gitsigns) == 'table' then
                opts = vim.tbl_deep_extend('force', opts, config.plugins.gitsigns)
            end

            local gitsigns = require 'gitsigns'
            local keymap = require('keymap')
            gitsigns.setup(opts)

            -- Helper for staging hunks, detects visual mode.
            local function stage_hunk()
                local mode = vim.api.nvim_get_mode().mode:sub(1,1)
                if mode == 'V' then -- visual-line mode
                   local esc = vim.api.nvim_replace_termcodes('<Esc>', true, true, true)
                   vim.api.nvim_feedkeys(esc, 'x', false) -- exit visual mode
                   vim.cmd("'<,'>Gitsigns stage_hunk")
                else
                   vim.cmd("Gitsigns stage_hunk")
                end
            end

            _G.HydraMappings["Root"]["Plugins"].g = { 'Git', function() keymap:runHydra('Git') end, { exit = true } }

            _G.HydraMappings["Git"]["Gitsigns"].n = { 'Next Hunk',          gitsigns.next_hunk, {}}
            _G.HydraMappings["Git"]["Gitsigns"].p = { 'Prev Hunk',          gitsigns.prev_hunk, {}}
            _G.HydraMappings["Git"]["Gitsigns"].S = { 'Stage Buffer',       gitsigns.stage_buffer, {} }
            _G.HydraMappings["Git"]["Gitsigns"].s = { 'Stage Hunk',         stage_hunk, {} }
            _G.HydraMappings["Git"]["Gitsigns"].u = { 'Undo Stage Hunk',    gitsigns.undo_stage_hunk, {}}
            _G.HydraMappings["Git"]["Gitsigns"].r = { 'Reset Hunk',         gitsigns.reset_hunk, {}}
            _G.HydraMappings["Git"]["Gitsigns"].R = { 'Reset Buffer',       gitsigns.reset_buffer, {}}
            _G.HydraMappings["Git"]["Gitsigns"].b = { 'Blame Current Line', function() gitsigns.blame_line { full = true } end, { exit = true }}
            _G.HydraMappings["Git"]["Gitsigns"].v = { 'Highlight Numbers',  gitsigns.toggle_linehl, { exit = true }}
            _G.HydraMappings["Git"]["Gitsigns"].V = { 'Highlight Lines',    gitsigns.toggle_numhl, { exit = true }}
        end
    }
end
