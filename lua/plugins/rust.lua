return function(use)
    -- Enable Rust.vim's automatic Rustfmt on save.
    vim.g.rustfmt_autosave = 1

    use { 'simrat39/rust-tools.nvim',
        config = function()
            require('rust-tools').setup {}
        end
    }

    use { 'rust-lang/rust.vim',
        config = function()
        end
    }
end
