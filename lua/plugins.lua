-- Neovim Configuration, 100% Lua Inside!
--
-- TODO: Rust Crate Graph as ASCII.
-- TODO: Find a way to Container Shell in tab.

local scrollbar = false
local sidebar   = false
local theme     = 'tokyonight'

-- Install Packer
-- ------------------------------------------------------------------------------------
local function ensure_packer()
    local packer = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if vim.fn.empty(vim.fn.glob(packer)) > 0 then
        vim.fn.system({
            'git',
            'clone',
            '--depth', '1',
            'https://github.com/wbthomason/packer.nvim',
            packer
        })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_installed = ensure_packer()

-- Configure Plugins
-- ------------------------------------------------------------------------------------
return require('packer').startup(function()
    use 'wbthomason/packer.nvim'

    -- Theming
    -- --------------------------------------------------------------------------------
    require('plugins/nvim-web-devicons')(use)
    require('plugins/twilight')(use)
    require('themes')(use, theme)

    -- IDE
    -- --------------------------------------------------------------------------------
    require('plugins/centerbuf')(use)
    require('plugins/auto-session')(use)
    require('plugins/comment')(use)
    require('plugins/diffview')(use)
    require('plugins/gitsigns')(use)
    require('plugins/harpoon')(use)
    require('plugins/hydra')(use)
    require('plugins/leap')(use)
    require('plugins/marks')(use)
    require('plugins/mind')(use)
    require('plugins/octo')(use)
    require('plugins/telescope')(use)
    require('plugins/toggleterm')(use)
    require('plugins/trouble')(use)
    require('plugins/which-key')(use)
    require('plugins/reach')(use)
    require('plugins/dirbuf')(use)
    require('plugins/neotest')(use)
    require('plugins/chatgpt')(use)
    require('plugins/mini')(use)

    -- Conditional Plugins
    __ = (scrollbar and require('plugins/scrollbar')(use))
    __ = (sidebar   and require('plugins/sidebar')(use))

    -- Quick `use` plugins.
    use 'tpope/vim-fugitive'
    use 'tpope/vim-repeat'
    use 'tpope/vim-vinegar'
    use 'tpope/vim-surround'
    use 'unblevable/quick-scope'
    use 'ibhagwan/fzf-lua'
    use 'uga-rosa/ccc.nvim'

    -- EasyAlign Bindings.
    use { 'junegunn/vim-easy-align',
        config = function()
            vim.cmd [[
                xmap ga <Plug>(EasyAlign)
                nmap ga <Plug>(EasyAlign)
            ]]
        end
    }

    -- Zen Mode Bindings
    use { 'folke/zen-mode.nvim',
        config = function()
            require 'zen-mode'.setup {
                window = {
                    backdrop = 1,
                    width    = 0.7,
                    height   = 0.9,
                },
                plugins = {
                    gitsigns = { enabled = false },
                    twilight = { enabled = false },
                },
            }

            -- Bind :ZenMode to <leader>z
            vim.api.nvim_set_keymap('n', '<leader>z', '<cmd>ZenMode<CR>', {
                noremap = true,
                silent  = true,
            })
        end,
    }


    -- Completion
    -- --------------------------------------------------------------------------------
    require('plugins/cmp')(use)

    use 'github/copilot.vim'


    -- Languages & LSP
    -- --------------------------------------------------------------------------------
    require('plugins/rust')(use)
    require('plugins/lspconfig')(use)
    require('plugins/treesitter')(use)

    use 'hashivim/vim-terraform'
    use 'tomlion/vim-solidity'
    use 'iden3/vim-circom-syntax'
    use 'LnL7/vim-nix'
    use { 'eraserhd/parinfer-rust', run = 'cargo build --release' }


    -- Fun
    -- --------------------------------------------------------------------------------
    vim.g.cryptoprice_base_currency = 'usd'
    vim.g.cryptoprice_crypto_list   = { 'bitcoin', 'ethereum', 'solana' }
    vim.g.cryptoprice_window_width  = 60
    vim.g.cryptoprice_window_height = 10
    use 'gaborvecsei/cryptoprice.nvim'

    if packer_installed then
        require('packer').sync()
    end
end)
