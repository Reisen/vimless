return function(use, theme)
    vim.g.dracula_show_end_of_buffer = true

    -- Lush is used in other themes, so comes first.
    use 'rktjmp/lush.nvim'

    use 'nyoom-engineering/oxocarbon.nvim'
    use 'Mofiqul/dracula.nvim'
    use 'mcchrish/zenbones.nvim'
    use 'folke/tokyonight.nvim'

    -- Choose default startup theme set in initial config.
    vim.cmd ([[
        set termguicolors
        set background=dark
        colorscheme ]] .. theme .. [[
    ]])
end

