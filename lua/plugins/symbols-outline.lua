return function(use)

    use { 'simrat39/symbols-outline.nvim',
        config = function()
            vim.g.symbols_outline = {
                position = 'left',
            }
        end
    }
end
