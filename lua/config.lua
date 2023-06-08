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
    -- Additional plugins can be added using the package syntax provided by lazy.nvim
    -- ------------------------------------------------------------------------------------
    custom = {
        'LnL7/vim-nix',
        { 'eraserhd/parinfer-rust', build = 'cargo build --release' },
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
        diffview          = true,
        dirbuf            = true,
        fidget            = true,
        fugitive          = true,
        gitsigns          = true,
        hydra             = true,
        indent_blankline  = true,
        leap              = true,
        lspconfig         = true,
        marks             = true,
        mini              = true,
        neotest           = true,
        neotree           = true,
        nvim_tree         = true,
        nvim_web_devicons = true,
        octo              = true,
        quickscope        = true,
        rust              = true,
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

        -- Included but Disabled Plugins
        auto_session      = false,
        bufferline        = false,
        centerbuf         = false,
        dropbar           = false,
        fzf_lua           = false,
        harpoon           = false,
        lualine           = false,
        mind              = false,
        neogit            = false,
        onedark           = false,
        tokyonight        = false,
        vinegar           = false,

        -- Example for overriding options for plugins/foo.lua
        foo = {
            setting_a = 'foo',
            setting_b = false,
        },

        -- Example for overriding the entire setup for plugins/bar.lua
        bar = function()
            require 'example/bar'.setup {}
        end,
    }
}
