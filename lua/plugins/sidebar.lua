return function(use)
    use { 'sidebar-nvim/sidebar.nvim',
        config = function()
            require 'sidebar-nvim'.setup {
                open     = true,
                sections = {
                    'todos',
                    'containers',
                    'symbols',
                },

                -- Configure Components.
                git         = {},
                diagnostics = {},
                todos       = { initially_closed = true, },

                -- Assume Podman.
                containers = {
                    use_podman   = true,
                    attach_shell = '/bin/sh',
                    interval     = 10000,
                },
            }
        end
    }
end
