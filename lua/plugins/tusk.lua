local M = {
    command     = '',
    completions = {}
}

-- A Telescope extension that provides a cmdline mode.
local function __telescope_extension_cmdline(opts)
    require("telescope.pickers").new(opts, {
        -- Onyx is the name of the prompt.
        prompt_title = "Onyx",

        -- Finder defines the data source for the picker.
        finder = require("telescope.finders").new_table({
            results = (function()
                -- Get the list of existing Vim commands.
                local commands = {}
                for _, cmd in pairs(vim.api.nvim_get_commands({})) do
                    table.insert(commands, cmd)
                end

                -- Check if we want buffer-local commands too.
                local need_buf_command = vim.F.if_nil(opts.show_buf_command, true)

                if need_buf_command then
                    local buf_command_iter = vim.api.nvim_buf_get_commands(0, {})
                    buf_command_iter[true] = nil     -- remove the redundant entry
                    for _, cmd in pairs(buf_command_iter) do
                        table.insert(commands, cmd)
                    end
                end

                return commands
            end)(),

            entry_maker = opts.entry_maker or require("telescope.make_entry").gen_from_commands(opts)
        }),

        -- Sorting is done by the generic sorter for now.
        sorter = require("telescope.config").values.generic_sorter(opts),

        attach_mappings = function(prompt_bufnr, map)
            local actions      = require("telescope.actions")
            local action_state = require("telescope.actions.state")
            local utils        = require("telescope.utils")

            actions.select_default:replace(function()
                -- Reset the Completion tracker.
                M.completions = {}
                M.command     = ''

                -- Try and get the current picker selection from the state.
                local selection = action_state.get_selected_entry()

                -- The only time we have no selection is if the user has
                -- filtered to nothing. In that case we just close the
                -- picker and warn.
                if selection == nil then
                    utils.__warn_no_selection "builtin.commands"
                    return
                end

                -- Now we can close the picker.
                actions.close(prompt_bufnr)

                -- We want to get the value chosen by the user. We will
                -- format it as a command but we don't intend to execute it
                -- yet, just store it.
                local val = selection.value
                local cmd = string.format([[:%s ]], val.name)

                -- If there are no argments at all, let's just run the command and go.
                if val.nargs == "0" then
                    vim.cmd(cmd)
                    vim.fn.histadd("cmd", val.name)
                    return
                end

                -- If there are arguments, we want to try and complete the next one
                -- so lets get completions.
                local completions = vim.fn.getcompletion(cmd, "cmdline")

                -- Append completions to our module completion tracker.
                M.command = cmd
                table.insert(M.completions, completions)

                -- We now want to chain invoke our completion picker.
                _G.__telescope_extension_cmdline_completion()

                --
                -- else
                --     vim.cmd [[stopinsert]]
                --     vim.fn.feedkeys(cmd, "n")
                -- end
            end)

            return true
        end,
    })
    :find()
end

-- We now need a second Telescope extension that provides a cmdline completion
-- based on the value in M.completions
function _G.__telescope_extension_cmdline_completion()
    local opts = require("telescope.themes").get_dropdown({
        borderchars = {
            prompt = {
                "─",
                "│",
                "─",
                "│",
                "┌",
                "┐",
                "┘",
                "└"
            },
            results = {
                " ",
                "│",
                "─",
                "│",
                "│",
                "│",
                "┘",
                "└"
            },
            preview = {
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " ",
                " "
            }
        }
    })

    require("telescope.pickers").new(opts, {
        -- Onyx is the name of the prompt.
        prompt_title = "Onyx (" .. M.command .. ")",

        -- Finder defines the data source for the picker.
        finder = require("telescope.finders").new_table({
            results     = M.completions[#M.completions],
            entry_maker = function(entry)
                return require 'telescope.make_entry'.set_default_entry_mt {
                    value   = entry,
                    ordinal = entry,
                    display = entry,
                }
            end
        }),

        -- Sorting is done by the generic sorter for now.
        sorter = require("telescope.config").values.generic_sorter(opts),

        attach_mappings = function(prompt_bufnr)
            local actions      = require("telescope.actions")
            local action_state = require("telescope.actions.state")
            local utils        = require("telescope.utils")

            actions.select_default:replace(function()
                -- Try and get the current picker selection from the state.
                local selection = action_state.get_selected_entry()

                -- The only time we have no selection is if the user has
                -- filtered to nothing. In that case we just close the
                -- picker and warn.
                if selection == nil then
                    utils.__warn_no_selection "builtin.commands"
                    return
                end

                -- Now we can close the picker and append the selection to the
                -- command. Which we can then use to complete again.
                actions.close(prompt_bufnr)

                -- Concatenate the argument.
                local val = selection.value
                local cmd = string.format([[%s%s ]], M.command, val.name)
                local cmd = M.command .. selection.value
                local cmd = string.format([[:%s ]], val.name)

                -- Get completions for the new command.
                local completions = vim.fn.getcompletion(cmd, "cmdline")

                -- Append completions to our module completion tracker.
                M.command = cmd
                table.insert(M.completions, completions)

                -- We now want to chain invoke our completion picker.
                _G.__telescope_extension_cmdline_completion()
            end)

            return true
        end,
    })
    :find()
end

require 'telescope'.register_extension {
    cmdline = __telescope_extension_cmdline,
    exports = {
        cmdline = __telescope_extension_cmdline,
    },
}
