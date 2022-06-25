return function(use)
    use { 'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup {}
        end
    }

    use { 'folke/todo-comments.nvim',
        config = function()
            require('todo-comments').setup {}
        end
    }
end
