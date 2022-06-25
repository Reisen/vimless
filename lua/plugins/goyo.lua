return function(use)
    use { 'junegunn/limelight.vim',
        requires = 'junegunn/goyo.vim',
        config   = function()
            vim.cmd [[
                autocmd! User GoyoEnter Limelight
                autocmd! User GoyoLeave Limelight!
            ]]
        end
    }
end
