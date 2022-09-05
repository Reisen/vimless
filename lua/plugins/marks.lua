return function(use)
    use { 'chentoast/marks.nvim',
        config = function()
            require('marks').setup {
                default_mappings = true,
                signs            = true,
            }
        end
    }
end
