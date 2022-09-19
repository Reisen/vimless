return function(use)
    use { 'folke/todo-comments.nvim',
        config = function()
            require('todo-comments').setup {
                highlight = {
                    before        = "",
                    keyword       = "bg",
                    after         = "",
                },
                gui_style = {
                    fg = "NONE",
                    bg = "NONE",
                },
            }
        end
    }
end
