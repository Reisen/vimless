return function(config)
    if type(config.plugins.leap) == 'boolean' and not config.plugins.leap then
        return {}
    end

    return {
        'ggandor/leap.nvim',
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

            -- Bind `leap_to_window` to <leader><space> for quick window
            -- switching.
            vim.api.nvim_set_keymap(
                'n',
                '<leader><space>',
                '<cmd>lua LeapToWindow()<CR>',
                {
                    noremap = true,
                    silent  = true,
                }
            )
        end
    }
end
