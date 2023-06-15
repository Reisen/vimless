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
            vim.cmd [[
                " Setup indent-blankline colors for the current colorscheme. Use ctermfg=8, NONE for gui.
                highlight IndentBlanklineIndent1 ctermfg=8 ctermbg=NONE guifg=NONE guibg=NONE
                highlight IndentBlanklineIndent2 ctermfg=8 ctermbg=NONE guifg=NONE guibg=NONE
                highlight IndentBlanklineChar    ctermfg=8 ctermbg=NONE guifg=NONE guibg=NONE
            ]]

            local opts = {
                space_char_blankline           = ' ',
                show_current_context           = false,
                show_current_context_start     = false,
                show_trailing_blankline_indent = true,
            }

            require 'indent_blankline'.setup(opts)
        end
    }
end
