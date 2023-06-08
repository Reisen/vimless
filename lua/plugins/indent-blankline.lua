return function(config)
    if type(config.plugins.indent_blankline) == 'boolean' and not config.plugins.indent_blankline then
        return {}
    end

    return {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            if config.plugins.indent_blankline and type(config.plugins.indent_blankline) == 'function' then
                config.plugins.indent_blankline()
                return
            end

            vim.opt.list = true
            vim.cmd [[highlight IndentBlanklineIndent1 guifg=#333435 gui=nocombine]]
            vim.cmd [[highlight IndentBlanklineIndent2 guifg=#333435 gui=nocombine]]

            local opts = {
                space_char_blankline           = ' ',
                show_current_context           = true,
                show_current_context_start     = false,
                show_trailing_blankline_indent = false,
                char_highlight_list            = {
                    "IndentBlanklineIndent1",
                    "IndentBlanklineIndent2",
                },
                space_char_highlight_list      = {
                    "IndentBlanklineIndent1",
                    "IndentBlanklineIndent2",
                },
            }

            require 'indent_blankline'.setup(opts)
        end
    }
end
