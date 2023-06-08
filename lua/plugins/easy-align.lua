return function(config)
    if type(config.plugins.easy_align) == 'boolean' and not config.plugins.easy_align then
        return {}
    end

    return {
       'junegunn/vim-easy-align',
        config = function()
            if config.plugins.easy_align and type(config.plugins.easy_align) == 'function' then
                config.plugins.easy_align()
                return
            end

            vim.cmd [[
                xmap ga <Plug>(EasyAlign)
                nmap ga <Plug>(EasyAlign)
            ]]
        end
    }
end

