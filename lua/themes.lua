return function(use, theme)
    vim.g.dracula_show_end_of_buffer = true

    -- Lush is used in other themes, so comes first.
    use 'rktjmp/lush.nvim'

    use 'B4mbus/oxocarbon-lua.nvim'
    use 'Mofiqul/dracula.nvim'
    use 'mcchrish/zenbones.nvim'
    use 'folke/tokyonight.nvim'

    vim.cmd ([[
        set termguicolors
        set background=dark
        colorscheme ]] .. theme .. [[
    ]])
end

