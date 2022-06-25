return function(use)
    use { 'chentoast/marks.nvim',
        config = function()
            require('marks').setup {
                default_mappings = true,
                signs            = true,
            }
        end
    }

    use { 'ThePrimeagen/harpoon',
        config = function()
            require('harpoon').setup {
                -- require('telescope').load_extension('harpoon')
            }
        end
    }
end
