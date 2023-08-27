---@diagnostic disable: unused-local

return function(config)
    if type(config.plugins.mini) == 'boolean' and not config.plugins.mini then
        return {}
    end

    return {
        'echasnovski/mini.nvim',
        priority = 800,
        config   = function()
            if config.plugins.mini and type(config.plugins.mini) == 'function' then
                config.plugins.mini()
                return
            end

            local b16m = {
                base00 = 0,
                base01 = 18,
                base02 = 19,
                base03 = 8,
                base04 = 20,
                base05 = 7,
                base06 = 21,
                base07 = 15,
                base08 = 1,
                base09 = 16,
                base0A = 3,
                base0B = 2,
                base0C = 6,
                base0D = 4,
                base0E = 5,
                base0F = 17,
            }

            -- Add Aliases to b16 base numbers.
            b16m.bg_def = b16m.base00
            b16m.bg_bar = b16m.base01
            b16m.bg_sel = b16m.base02
            b16m.bg_lgt = b16m.base07
            b16m.fg_def = b16m.base05
            b16m.fg_drk = b16m.base04
            b16m.fg_lgt = b16m.base06

            local treespec = require 'mini.ai'.gen_spec.treesitter
            local opts = {
                align       = {},
                basics      = {},
                bracketed   = {},
                bufremove   = {},
                clue        = {},
                colors      = {},
                comment     = {},
                completion  = {},
                cursorword  = {},
                doc         = {},
                fuzzy       = {},
                hipatterns  = {},
                hues        = {},
                indentscope = {},
                jump        = {},
                jump2d      = {},
                map         = {},
                misc        = {},
                move        = {},
                operators   = {},
                pairs       = {},
                sessions    = {},
                splitjoin   = {},
                starterkit  = {},
                statusline  = {},
                surround    = {},
                tabline     = {},
                test        = {},
                trailspace  = {},

                animate = {
                    cursor = { enable = false },
                    scroll = { enable = false },
                    resize = { enable = false },
                    open   = { enable = false },
                    close  = { enable = false },
                },

                ai = {
                    custom_textobjects = {
                        e     = treespec({ a = '@assignment.outer', i = '@assignment.inner', }),
                        b     = treespec({ a = '@block.outer', i = '@block.inner', }),
                        c     = treespec({ a = '@call.outer', i = '@call.inner', }),
                        d     = treespec({ a = '@class.outer', i = '@class.inner', }),
                        f     = treespec({ a = '@function.outer', i = '@function.inner', }),
                        s     = treespec({ a = '@scope', i = '@scope', }),
                        ["/"] = treespec({ a = '@comment.outer', i = '@comment.outer', }),
                    },

                    mappings = {
                        around_last = '',
                        inside_last = '',
                    },
                },

                base16 = {
                    plugins = { default = true },

                    -- Set all base colors to black, as we're targetting cterm not gui.
                    palette   = {
                        base00 = "#000000",
                        base01 = "#000000",
                        base02 = "#000000",
                        base03 = "#000000",
                        base04 = "#000000",
                        base05 = "#000000",
                        base06 = "#000000",
                        base07 = "#000000",
                        base08 = "#000000",
                        base09 = "#000000",
                        base0A = "#000000",
                        base0B = "#000000",
                        base0C = "#000000",
                        base0D = "#000000",
                        base0E = "#000000",
                        base0F = "#000000",
                    },

                    -- Assign bases to the correct base16 colours.
                    use_cterm = {
                        base00 = 0,
                        base01 = 18,
                        base02 = 19,
                        base03 = 8,
                        base04 = 20,
                        base05 = 7,
                        base06 = 21,
                        base07 = 15,
                        base08 = 1,
                        base09 = 16,
                        base0A = 3,
                        base0B = 2,
                        base0C = 6,
                        base0D = 4,
                        base0E = 5,
                        base0F = 17,
                    }
                },

                files = {
                    options = {
                        use_as_default_explorer = false,
                    },
                },
            }

            if config.plugins.mini and type(config.plugins.mini) == 'table' then
                opts = vim.tbl_deep_extend('force', opts, config.plugins.mini)
            end

            -- Forward Mini Configuration files to Mini Setup handlers.
            for plugin in pairs(opts) do
                if opts[plugin] then
                    require('mini.' .. plugin).setup(opts[plugin])
                end
            end

            _G.HydraMappings['Buffer']['Other'].d    = { 'Delete Buffer', require 'mini.bufremove'.delete, {} }
            _G.HydraMappings['Root']['Plugins']['-'] = { 'MiniFiles',     require 'mini.files'.open, { exit = true } }

            -- mini.base16 configures most colours perfectly, but gets a few that look a little gnarly.
            -- Here we override some of those colours by defining an autocommand that override some of
            -- those highlights whenever a new buffer is opened.
            ---@diagnostic disable-next-line: unused-local
            local base16_highlighter = vim.api.nvim_create_augroup("Base16Override", {
                clear = true
            });

            vim.api.nvim_create_autocmd({"BufEnter"}, {
                pattern  = "*",
                group    = base16_highlighter,
                callback = function()
                    local hl = function(name, bg, fg, attr)
                        vim.cmd(string.format(
                            'highlight %s ctermbg=%s ctermfg=%s cterm=%s',
                            name,
                            bg   or 'NONE',
                            fg   or 'NONE',
                            attr or 'NONE'
                        ))
                    end

                    local bg = function(name, bg)
                        vim.cmd(string.format(
                            'highlight %s ctermbg=%s',
                            name,
                            bg or 'NONE'
                        ))
                    end

                    local fg = function(name, fg)
                        vim.cmd(string.format(
                            'highlight %s ctermfg=%s',
                            name,
                            fg or 'NONE'
                        ))
                    end

                    hl('Normal',                b16m.bg_def, b16m.fg_def)
                    bg('DiagnosticSignError',   nil)
                    bg('DiagnosticSignError',   nil)
                    bg('DiagnosticSignHint',    nil)
                    bg('DiagnosticSignInfo',    nil)
                    bg('DiagnosticSignWarn',    nil)
                    bg('GitSignsAdd',           nil)
                    bg('GitSignsChange',        nil)
                    bg('GitSignsDelete',        nil)
                    bg('GitSignsUntracked',     nil)
                    bg('HydraHint',             nil)
                    bg('HydraSelected',         nil)
                    bg('WhichKeyFloat',         nil)
                    bg('WhichKeySeparator',     nil)
                    fg('EndOfBuffer',           b16m.bg_def)
                    hl('FlashCurrent',          nil, b16m.base0A)
                    hl('FlashLabel',            nil, b16m.base0B, 'underline,bold')
                    hl('FlashMatch',            nil, b16m.base08)
                    bg('LazyNormal',            b16m.bg_def)
                    hl('GitSignsAddLn',         b16m.bg_bar, nil)
                    hl('GitSignsChangeLn',      b16m.bg_bar, nil)
                    hl('GitSignsDeleteLn',      b16m.bg_bar, nil)
                    hl('GitSignsUntrackedLn',   b16m.bg_bar, nil)
                    hl('GitSignsUntrackedLn',   b16m.bg_bar, nil)
                    hl('HydraBorder',           nil, b16m.fg_drk)
                    hl('LineNr',                nil, b16m.base03)
                    hl('MiniFilesBorder',       b16m.bg_def, b16m.base0D)
                    hl('MiniFilesNormal',       b16m.bg_def)
                    hl('MiniFilesTitle',        b16m.bg_def)
                    hl('MiniFilesTitleFocused', b16m.bg_def)
                    hl('NeoTreeWinSeparator',   nil, b16m.bg_def)
                    hl('QuickScopePrimary',     nil, b16m.base08, 'underline')
                    hl('QuickScopeSecondary',   nil, b16m.base03)
                    hl('SignColumn',            nil, nil)
                    hl('StatusLineNC',          b16m.bg_def, b16m.base03)
                    hl('StatusLine',            nil, b16m.base0D)
                    hl('TabLineFill',           nil, b16m.base03)
                    hl('TabLine',               nil, b16m.base03)
                    hl('TabLineSel',            nil, b16m.base08)
                    hl('TelescopeBorder',       nil, b16m.base03)
                    hl('TelescopeTitle',        nil, b16m.base0D)
                    hl('Twilight',              nil, b16m.base03)
                    hl('WinBar',                b16m.bg_bar, b16m.fg_def)
                    hl('WinBarNC',              b16m.bg_bar, b16m.fg_lgt)
                    hl('WinSeparator',          nil, b16m.bg_def)
                end
            })
        end
    }
end
