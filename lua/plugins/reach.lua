return function(use)
    use { 'toppair/reach.nvim',
        config = function()
            local reach_options = {
                handle       = 'dynamic',
                show_current = true,
                sort         = function(a, b)
                    return vim.fn.getbufinfo(a)[1].lastused > vim.fn.getbufinfo(b)[1].lastused
                end,
            }

            -- Bind Reach to <leader>j
            function _G.reach_jumper()
                require('reach').buffers(reach_options)
            end

            vim.api.nvim_set_keymap('n', '<leader>j', '<cmd>lua reach_jumper()<CR>', {
                noremap = true,
                silent  = true,
            })

            require 'reach'.setup {}
        end
    }
end
