return function(config)
    if type(config.plugins.diffview) == 'boolean' and not config.plugins.diffview then
        return {}
    end

    return {
        'sindrets/diffview.nvim',
        dependencies = 'nvim-lua/plenary.nvim',
        config       = function()
            if config.plugins.diffview and type(config.plugins.diffview) == 'function' then
                config.plugins.diffview()
                return
            end

            local opts = {
                enhanced_diff_hl = true
            }

            if config.plugins.diffview and type(config.plugins.diffview) == 'table' then
                opts = vim.tbl_deep_extend('force', opts, config.plugins.diffview)
            end

            require 'diffview'.setup(opts)
        end
    }
end
