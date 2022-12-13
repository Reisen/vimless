return function(use)
    use { 'folke/todo-comments.nvim',
        config = function()
            require('todo-comments').setup {
                signs     = false,
                highlight = {
                    before        = "",
                    keyword       = "bg",
                    after         = "",
                },
            }
        end
    }
end
