return function(config)
    if type(config.plugins.vim_repeat) == 'boolean' and not config.plugins.vim_repeat then
        return {}
    end

    return {
        'tpope/vim-repeat',
        config = function()
            if config.plugins.vim_repeat and type(config.plugins.vim_repeat) == 'function' then
                config.plugins.vim_repeat()
                return
            end
        end
    }
end


