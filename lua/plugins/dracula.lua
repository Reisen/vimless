return function(use)
    vim.g.dracula_show_end_of_buffer = true

    -- Dracula Theme.
    use { 'Mofiqul/dracula.nvim',
        config = function()
            vim.cmd [[
                colorscheme dracula
            ]]
        end
    }
end
