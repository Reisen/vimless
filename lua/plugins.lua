-- Neovim Configuration, 99% Lua Inside!
--
-- TODO: Make global circles configurable.
-- TODO: Make LSP signs globally configurable.

local config = require('config')

-- Install Lazy.nvim
--
-- Lazy.nvim is required for package managemment, without it this entire config
-- will fail to work. Here we check if Lazy is installed, and if not, we
-- automatically try and install it for the user.
-- ------------------------------------------------------------------------------------
local function ensure_lazy()
    local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    local installed = false
    if not vim.loop.fs_stat(lazy_path) then
        installed = true
        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable", -- latest stable release
            lazy_path,
        })
    end

    vim.opt.rtp:prepend(lazy_path)
    return installed
end

---@diagnostic disable-next-line: unused-local
local lazy_installed = ensure_lazy()

-- Configure Plugins
-- ------------------------------------------------------------------------------------
require('lazy').setup(
    {
        -- If Hydra is enabled, it is loaded by priority. This is important because
        -- it is how we allow other plugins to hook into the navigation.
        require('plugins/hydra')(config),

        require('plugins/auto-session')(config),
        require('plugins/bufferline')(config),
        require('plugins/ccc')(config),
        require('plugins/centerbuf')(config),
        require('plugins/chatgpt')(config),
        require('plugins/circles')(config),
        require('plugins/cmp')(config),
        require('plugins/copilot')(config),
        require('plugins/diffview')(config),
        require('plugins/dirbuf')(config),
        require('plugins/easy-align')(config),
        require('plugins/fidget')(config),
        require('plugins/flash')(config),
        require('plugins/fugitive')(config),
        require('plugins/fzf-lua')(config),
        require('plugins/gitsigns')(config),
        require('plugins/hardtime')(config),
        require('plugins/hlchunk')(config),
        require('plugins/indent-blankline')(config),
        require('plugins/lazygit')(config),
        require('plugins/leap')(config),
        require('plugins/lspconfig')(config),
        require('plugins/marks')(config),
        require('plugins/mind')(config),
        require('plugins/mini')(config),
        require('plugins/neogit')(config),
        require('plugins/neotest')(config),
        require('plugins/neotree')(config),
        require('plugins/nvim-web-devicons')(config),
        require('plugins/octo')(config),
        require('plugins/oil')(config),
        require('plugins/quickscope')(config),
        require('plugins/repeat')(config),
        require('plugins/surround')(config),
        require('plugins/targets')(config),
        require('plugins/telescope')(config),
        require('plugins/todo-comments')(config),
        require('plugins/toggleterm')(config),
        require('plugins/treesitter')(config),
        require('plugins/trouble')(config),
        require('plugins/twilight')(config),
        require('plugins/vinegar')(config),
        require('plugins/which-key')(config),
        require('plugins/zen-mode')(config),

        -- Languages
        require('plugins/lisp')(config),
        require('plugins/nix')(config),
        require('plugins/rust')(config),
        require('plugins/zig')(config),

        -- Neovim comes with rust.vim, but a very outdated version (2017). Force
        -- updating this plugin regardless of config.
        'rust-lang/rust.vim',

        -- Unpack config.custom to finish off the list with any additional plugins.
        -- --------------------------------------------------------------------------------
        unpack(config.custom)
    },
    {
        ui = {
            size   = { width = 1, height = 1},
            wrap   = false,
        }
    }
)

-- Hook up the Keymapper
require('keymap'):bind()
