return function(config)
    if type(config.plugins.leap) == 'boolean' and not config.plugins.leap then
        return {}
    end

    return {
        'ggandor/leap.nvim',
        dependencies = {
            'ggandor/leap-spooky.nvim',
            'ggandor/leap-ast.nvim',
            'ggandor/flit.nvim',
        },
        config = function()
            if config.plugins.leap and type(config.plugins.leap) == 'function' then
                config.plugins.leap()
                return
            end

            require('leap').set_default_keymaps()

            ---@diagnostic disable-next-line: unused-function, unused-local
            function _G.LeapToWindow()
                local targets = {}
                local windows = require 'leap.util'.get_enterable_windows()

                -- Build a list of top-left corner window targets.
                for _, win in ipairs(windows) do
                    local info = vim.fn.getwininfo(win)[1]
                    local pos  = { info.topline, 1 }
                    table.insert(targets, {
                        pos     = pos,
                        wininfo = info
                    })
                end

                -- Give Leap the window targets.
                require('leap').leap {
                    target_windows = windows,
                    targets        = targets,
                    action         = function(target)
                        vim.api.nvim_set_current_win(
                            target.wininfo.winid
                        )
                    end
                }
            end

            -- Initialize Leap Spooky.
            require 'leap-spooky'.setup {
                op = false
            }

            require 'flit' .setup {
                labeled_modes = 'v',
            }

            -- Leap AST hooks pre-exist, we just need to bind them.
            vim.keymap.set({'n', 'x', 'o'}, '\'', function() require'leap-ast'.leap() end, {})
        end
    }
end
