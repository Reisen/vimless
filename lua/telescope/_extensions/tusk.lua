local M = {
    command = {},
    nargs   = 0,
    opts    = {},
}

-- The gsub function in Lua performs global substitution of patterns in a
-- string. Here, various patterns are matched and substituted to convert the
-- string into kebab case.
local function case_convert(s)
    -- Match any uppercase letter after a non-letter character and replace with
    -- a hyphen.
    s = s:gsub('%f[^%l]%u', '-%1')
    -- Match any digit after a non-alphabetic character and replace with a
    -- hyphen.
    s = s:gsub('%f[^%a]%d', '-%1')
    -- Match any alphabetic character after a non-digit character and replace
    -- with a hyphen.
    s = s:gsub('%f[^%d]%a', '-%1')
    -- Match a capital letter followed by another capital letter followed by a
    -- lowercase letter. Insert a hyphen between the first and second capital
    -- letters.
    s = s:gsub('(%u)(%u%l)', '%1-%2')

    -- Return the resulting string in lowercased kebab-case format.
    return s:lower()
end

-- A Telescope extension that provides a cmdline mode.
local function __telescope_extension_cmdline(defaults, completions)
    local entry_display = require 'telescope.pickers.entry_display'
    local pickers       = require 'telescope.pickers'
    local finders       = require 'telescope.finders'
    local config        = require 'telescope.config'

    local opts = vim.tbl_deep_extend('force', M.opts, defaults or {})

    pickers.new(opts, {
        prompt_title = "Tusk",
        sorter       = config.values.generic_sorter(opts),
        finder       = finders.new_table({
            results = (function()
                if not completions then
                    M.command = {}

                    -- Get the list of existing Vim commands.
                    local results = vim.fn.getcompletion(':'..table.concat(M.command, ' ')..' ', "cmdline")

                    -- Also get the list of defined user-commands, the reason we
                    -- don't just use this as the result is because neovim does not
                    -- provide builtin commands in this list. Instead, we'll match
                    -- up our completion results to this list to get as
                    -- comprehensive a list as possible, unfortunately this won't
                    -- cover everything but it's the best we can do.
                    local user_commands   = vim.api.nvim_get_commands({ builtin = false })
                    local buffer_commands = vim.api.nvim_buf_get_commands(0, { builtin = true })
                    buffer_commands[true] = nil

                    -- Generate Table of all commands zipped with information if present.
                    local commands = {}
                    for _, command in ipairs(results) do
                        if user_commands[command] then
                            table.insert(commands, user_commands[command])
                        elseif buffer_commands[command] then
                            table.insert(commands, buffer_commands[command])
                        else
                            table.insert(commands, {
                                nargs      = "?",
                                name       = command,
                                definition = 'No description.',
                            })
                        end
                    end

                    return commands
                end

                return vim.fn.getcompletion(':'..table.concat(M.command, ' ')..' ', "cmdline")
            end)(),

            entry_maker = opts.entry_maker or function(entry)
                -- If we're showing completions, we don't have a rich entry
                -- table and should format a preview of the command instead.
                if completions then
                    local current_command = case_convert(table.concat(M.command, ' '))
                    local display = function(row)
                        local displayer = entry_display.create {
                            separator = " ",
                            items = {
                                { width     = 2 },
                                { width     = #current_command },
                                { remaining = true },
                            },
                        }

                        return displayer {
                            { M.nargs,                      "TelescopeResultsNumber" },
                            { current_command,              "TelescopeResultsFunction" },
                            { case_convert(row.value.name), "TelescopeResultsIdentifier" },
                        }
                    end

                    return require 'telescope.make_entry'.set_default_entry_mt {
                        ordinal = entry,
                        display = display,
                        value   = {
                            nargs = M.nargs,
                            name  = entry,
                        },
                    }
                end

                local display = function(row)
                    local template = {
                        { width     = 2 },
                        { width     = 50 },
                        { remaining = true },
                    }

                    if opts.visual then
                        table.insert(template, 2, { width = 5 })
                    end

                    local displayer = entry_display.create {
                        separator = " ",
                        items     = template,
                    }

                    local items = {
                        { row.value.nargs,              "TelescopeResultsNumber" },
                        { case_convert(row.value.name), "TelescopeResultsIdentifier" },
                        { row.value.definition,         "TelescopeResultsComment" },
                    }

                    if opts.visual then
                        table.insert(items, 2, { "'<'>", "TelescopeResultsLabel" })
                    end

                    return displayer(items)
                end

                return require 'telescope.make_entry'.set_default_entry_mt {
                    display = display,
                    ordinal = case_convert(entry.name),
                    value   = entry,
                }
            end
        }),

        attach_mappings = function(prompt_bufnr, map)
            local actions      = require("telescope.actions")
            local action_state = require("telescope.actions.state")
            local utils        = require("telescope.utils")

            -- Bind Shift=Enter to immediately exit and execute the current
            -- buffered command string.
            map('i', '<S-cr>', function(_prompt_bufnr)
                if action_state.get_selected_entry() ~= nil then
                    table.insert(M.command, action_state.get_selected_entry().value.name)
                end

                actions.close(_prompt_bufnr)
                vim.cmd(table.concat(M.command, " "))
                vim.fn.histadd("cmd", table.concat(M.command, " "))
            end)

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

                -- Now we can close the current picker.
                actions.close(prompt_bufnr)

                -- Append the selected command to the command buffer.
                table.insert(M.command, selection.value.name)

                -- Attempt to get completions ahead of time, because if there
                -- are none we are able to execute the command immediately and
                -- finish instead of recursing to another picker.
                local pre_completions = vim.fn.getcompletion(':'..table.concat(M.command, ' ')..' ', "cmdline")
                if not pre_completions or #pre_completions == 0 then
                    vim.cmd(table.concat(M.command, " "))
                    vim.fn.histadd("cmd", table.concat(M.command, " "))
                    return
                end

                -- Command is incomplete, so we recurse to another picker.
               __telescope_extension_cmdline(opts, true)
            end)

            return true
        end,
    })
    :find()
end

return require 'telescope'.register_extension {
    setup = function(opts)
        M.opts = opts
    end,

    exports = {
        tusk = __telescope_extension_cmdline,
    },
}
