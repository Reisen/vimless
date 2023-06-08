return function(config)
    if type(config.plugins.todo_comments) == 'boolean' and not config.plugins.todo_comments then
        return
    end

    return {
        'folke/todo-comments.nvim',
        config = function()
            if config.plugins.todo_comments and type(config.plugins.todo_comments) == 'function' then
                config.plugins.todo_comments()
            else
                local opts = {
                    signs     = false,
                    highlight = {
                        before  = "",
                        keyword = "bg",
                        after   = "",
                    },
                }

                -- Merge user settings with defaults if they've been specified.
                if config.plugins.todo_comments and type(config.plugins.todo_comments) == 'table' then
                    opts = vim.tbl_extend('force', opts, config.plugins.todo_comments)
                end

                require('todo-comments').setup(opts)
            end
        end
    }
end
