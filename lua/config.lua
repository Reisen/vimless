-- Custom Configuration
--
-- This is where you can override the default configuration for vimless. This
-- file provides a set of vimless specific options, but also provides a means
-- to override specific plugin options, completely override plugin options, or
-- add your own plugins.
--
-- It should be possible to maintain just this file to configure vimless such
-- that upgrades should be as easy as `git pull --rebase` to apply your config
-- to whatever the latest vimless is.

return {
    -- Vimless Options
    -- ------------------------------------------------------------------------------------
    theme = 'base16-default-dark',

    -- Custom Plugins
    --
    -- Additional plugins can be added using the iackage syntax provided by lazy.nvim
    -- ------------------------------------------------------------------------------------
    custom = {
        { 'will133/vim-dirdiff' },
        { 'ojroques/vim-oscyank', branch = 'main'},
        { 'yorickpeterse/nvim-pqf', opts = {} },
    },

    -- Plugin Control
    --
    -- Control and configure plugins that are included with vimless. This is a table of
    -- entries that match up to plugins in lua/plugins/*.lua. Each entry can take several
    -- forms:
    --
    -- - If set to a bool, enables/disables a plugin.
    -- - If set to a table, the options are merged with the default options for the plugin.
    -- - If set to a function, this allows completely overriding the setup for that plugin.
    -- ------------------------------------------------------------------------------------
    plugins = {
        -- Enabled Plugins
        ccc               = true,
        chatgpt           = true,
        circles           = true,
        cmp               = true,
        conform           = true,
        diffview          = true,
        dirbuf            = true,
        fidget            = true,
        flash             = true, -- Conflicts with `leap`, enable only one or the other.
        fugitive          = true,
        gitsigns          = true,
        hlchunk           = true,
        hydra             = true,
        lazygit           = true,
        lspconfig         = true,
        marks             = true,
        neogit            = true,
        neotest           = true,
        neotree           = true,
        nvim_tree         = true,
        nvim_web_devicons = true,
        octo              = true,
        quickscope        = true,
        surround          = true,
        telescope         = true,
        todo_comments     = true,
        toggleterm        = true,
        treesitter        = true,
        trouble           = true,
        tusk              = true,
        twilight          = true,
        vim_repeat        = true,
        which_key         = true,
        zen               = true,

        mini = {
            animate     = false,
            basics      = false,
            clue        = false,
            colors      = false,
            completion  = false, -- Conflicts with `cmp`
            cursorword  = false,
            doc         = false,
            fuzzy       = false,
            hipatterns  = false,
            hues        = false,
            indentscope = false, -- Conflicts with `indent-blankline`
            jump        = false, -- Conflicts with `flash / leap`
            jump2d      = false, -- Conflicts with `flash / leap`
            map         = false,
            misc        = false,
            move        = false,
            sessions    = false, -- Conflicts with `auto-session`
            splitjoin   = false,
            starterkit  = false,
            statusline  = false,
            surround    = false, -- Conflicts with `surround` and `flash`
            tabline     = false,
            test        = false,
        },

        -- Language Specific Plugin Sets
        --
        -- These plugins enable any extensions, LSP configurations, and syntax
        -- configurations needed to efficiently work in a language. You can
        -- leave these all enabled as they are only loaded when you open a file
        -- that triggers the respective language.
        lisp              = true,
        nix               = true,
        rust              = true,
        zig               = true,

        -- Included but Disabled Plugins
        auto_session      = false,
        bufferline        = false,
        centerbuf         = false,
        dropbar           = false,
        easy_align        = false,
        fzf_lua           = false,
        hardtime          = false,
        harpoon           = false,
        indent_blankline  = false,
        leap              = false, -- Conflicts with `flash`, enable only one or the other.
        lualine           = false,
        mind              = false,
        oil               = false,
        onedark           = false,
        targets           = false,
        tokyonight        = false,
        vinegar           = false,

        -- Example for overriding options for a hypothetical plugin located in
        -- plugins/foo.lua
        foo = {
            setting_a = {},
            setting_b = false,
        },

        -- Example for overriding the entire setup for a hypothetical plugin
        -- located in plugins/bar.lua
        bar = function()
            require 'example/bar'.setup {}
        end,
    }
}
