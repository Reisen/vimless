return function(config)
    if type(config.plugins.tokyonight) == 'boolean' and not config.plugins.tokyonight then
        return {}
    end

    return {
        'folke/tokyonight.nvim',
        config = function()
            if config.plugins.tokyonight and type(config.plugins.tokyonight) == 'function' then
                config.plugins.tokyonight()
                return
            end

            vim.g.tokyonight_style                    = "day"
            vim.g.tokyonight_dark_float               = false
            vim.g.tokyonight_dark_sidebar             = true
            vim.g.tokyonight_day_brightness           = 0.8
            vim.g.tokyonight_italic_comments          = false
            vim.g.tokyonight_italic_keywords          = false
            vim.g.tokyonight_transparent              = false
            vim.g.tokyonight_hide_inactive_statusline = true
            vim.g.tokyonight_sidebars                 = {}
        end
    }
end
