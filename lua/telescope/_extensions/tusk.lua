local M = {
    command = {},
    nargs   = 0,
    opts    = {},
}

-- The gsub function in Lua performs global substitution of patterns in a
-- string. Here, various patterns are matched and substituted to convert the
-- string into kebab case.
function case_convert(s)
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
local function __telescope_extension_cmdline(opts, completions)
    local entry_display = require 'telescope.pickers.entry_display'
    local pickers       = require 'telescope.pickers'
    local finders       = require 'telescope.finders'
    local config        = require 'telescope.config'

    local opts = vim.tbl_deep_extend('force', M.opts, opts or {})

    pickers.new(opts, {
        prompt_title = "Tusk",
        sorter       = config.values.generic_sorter(opts),
        finder       = finders.new_table({
            results = (function()
                if not completions then
                    M.command = {}
                end

                -- Get the list of existing Vim commands.
                return vim.fn.getcompletion(':'..table.concat(M.command, ' ')..' ', "cmdline")
            end)(),

            entry_maker = opts.entry_maker or function(entry)
                -- If we're showing completions, we don't need to do any entry
                -- formatting, we can just produce an entry for each completion
                -- as it currently is.
                if completions then
                    local current_command = case_convert(table.concat(M.command, ' '))
                    local display = function(entry)
                        local displayer = entry_display.create {
                            separator = " ",
                            items = {
                                { width     = 2 },
                                { width     = #current_command },
                                { remaining = true },
                            },
                        }

                        return displayer {
                            { M.nargs,                        "TelescopeResultsNumber" },
                            { current_command,                "TelescopeResultsFunction" },
                            { case_convert(entry.value.name), "TelescopeResultsIdentifier" },
                        }
                    end

                    return require 'telescope.make_entry'.set_default_entry_mt {
                        ordinal = entry,
                        display = display,
                        value   = {
                            nargs      = 0,
                            name       = entry,
                            definition = '',
                        },
                    }
                end

                local display = function(entry)
                    local template = {
                        { width     = 2 },
                        { width     = 40 },
                        { remaining = true },
                    }

                    if opts.visual then
                        table.insert(template, 2, { width = 5 })
                    end

                    local displayer = entry_display.create {
                        separator = " ",
                        items     = template,
                    }

                    local row = {
                        { entry.value.nargs,              "TelescopeResultsNumber" },
                        { case_convert(entry.value.name), "TelescopeResultsIdentifier" },
                        { entry.value.definition,         "TelescopeResultsComment" },
                    }

                    if opts.visual then
                        table.insert(row, 2, { "'<'>", "TelescopeResultsLabel" })
                    end

                    return displayer(row)
                end

                return require 'telescope.make_entry'.set_default_entry_mt {
                    ordinal    = entry,
                    display    = display,
                    value      = {
                        nargs      = 0,
                        name       = entry,
                        definition = '',
                    },
                }
            end
        }),

        attach_mappings = function(prompt_bufnr, map)
            local actions      = require("telescope.actions")
            local action_state = require("telescope.actions.state")
            local utils        = require("telescope.utils")

            -- Bind Shift=Enter to immediately exit and execute the current
            -- buffered command string.
            map('i', '<C-e>', function(_prompt_bufnr)
                local selection = action_state.get_selected_entry()
                if selection ~= nil then
                    table.insert(M.command, selection.value.name)
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

                -- Attempt to get completions, because if there are none we are
                -- able to execute now.
                local completions = vim.fn.getcompletion(':'..table.concat(M.command, ' ')..' ', "cmdline")
                if not completions or #completions == 0 then
                    vim.cmd(table.concat(M.command, " "))
                    vim.fn.histadd("cmd", table.concat(M.command, " "))
                    return
                end

                -- If there are no expected argments at all, we can just run
                -- the command and we're done.
               -- if M.nargs == "0" then
               --      vim.cmd(table.concat(M.command, " "))
               --      vim.fn.histadd("cmd", table.concat(M.command, " "))
               --      return
               --  end

                -- If the nargs is numeric, we can decrement.
                -- if tonumber(M.nargs) then
                --     M.nargs = tostring(tonumber(M.nargs) - 1)
                -- end

                -- Now we re-run with completions.
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
