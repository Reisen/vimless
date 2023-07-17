local M = {
    -- Base Configuration for how to display Hydra windows.
    hint_options = {
        position = 'top-right',
        offset   = 0,
        border   = {
            '│', '', '', '', '', '', '', '│',
        },
    }
}

function M:setup(config)
    if not config or not config.plugins or not config.plugins.hydra then
        return function()
        end
    end

    self.mappings = {}

    -- We want accesses to this object to automatically create a new table
    -- if it doesn't exist. This should recursively apply, so newly made
    -- subtables should also have this behavior.
    --
    -- Additionally, we track inserts to capture ordering.
    self.mappings.__index = function(t, k)
        local v   = {}
        v.__order = {}
        setmetatable(v, self.mappings)
        local _ = rawget(t, '__order') and table.insert(t.__order, k)
        rawset(t, k, v)
        return v
    end

    -- Track inserts into the table.
    self.mappings.__newindex = function(t, k, v)
        if type(v) == "table" then
            v.__order = {}
            setmetatable(v, self.mappings)
        end
        local _ = rawget(t, '__order') and table.insert(t.__order, k)
        rawset(t, k, v)
    end

    setmetatable(self.mappings, self.mappings)

    -- Setup the default, built-in mappings.
    local c = require 'hydra.keymap-util'

    -- Window Management -----------------------------------------------------------
    self.mappings["Window"]["Window Navigation"].h  = {'Left', c.cmd('wincmd h'), {}}
    self.mappings["Window"]["Window Navigation"].j  = {'Down', c.cmd('wincmd j'), {}}
    self.mappings["Window"]["Window Navigation"].k  = {'Up', c.cmd('wincmd k'), {}}
    self.mappings["Window"]["Window Navigation"].l  = {'Right', c.cmd('wincmd l'), {}}
    self.mappings["Window"]["Window Swapping"].H    = {'Swap Left', c.cmd('wincmd H'), {}}
    self.mappings["Window"]["Window Swapping"].J    = {'Swap Down', c.cmd('wincmd J'), {}}
    self.mappings["Window"]["Window Swapping"].K    = {'Swap Up', c.cmd('wincmd K'), {}}
    self.mappings["Window"]["Window Swapping"].L    = {'Swap Right', c.cmd('wincmd L'), {}}
    self.mappings["Window"]["Window Swapping"].x    = {'Swap Previous', c.cmd('wincmd x'), {}}
    self.mappings["Window"]["Window Resizing"]["-"] = {'Decrease Height', c.cmd('resize -1'), {}}
    self.mappings["Window"]["Window Resizing"]["+"] = {'Increase Height', c.cmd('resize +1'), {}}
    self.mappings["Window"]["Window Resizing"]["<"] = {'Decrease Width', c.cmd('vertical resize -1'), {}}
    self.mappings["Window"]["Window Resizing"][">"] = {'Increase Width', c.cmd('vertical resize +1'), {}}
    self.mappings["Window"]["Window Resizing"]["="] = {'Balance Windows', c.cmd('wincmd ='), {}}
    self.mappings["Window"]["Window Splitting"].s   = {'Split Horizontal', c.cmd('wincmd s'), {}}
    self.mappings["Window"]["Window Splitting"].v   = {'Split Vertical', c.cmd('wincmd v'), {}}
    self.mappings["Window"]["Other"].c              = {'Close Window', c.cmd('wincmd c'), {}}
    self.mappings["Window"]["Other"].T              = {'Move Window to Tab', c.cmd('wincmd T'), { exit = true }}
    self.mappings["Window"]["Other"].q              = {'Quit', function() end, { exit = true }}

    -- Tab Management --------------------------------------------------------------
    self.mappings["Tab"]["Tab Navigation"]["0"] = {'First', c.cmd('tabfirst'), {}}
    self.mappings["Tab"]["Tab Navigation"]["9"] = {'Last', c.cmd('tablast'),  {}}
    self.mappings["Tab"]["Tab Navigation"].h    = {'Prev', c.cmd('tabprev'), {}}
    self.mappings["Tab"]["Tab Navigation"].l    = {'Next', c.cmd('tabnext'), {}}
    self.mappings["Tab"]["Tab Swapping"].H      = {'Move Tab Left', c.cmd('tabmove -'), {}}
    self.mappings["Tab"]["Tab Swapping"].L      = {'Move Tab Right', c.cmd('tabmove +'), {}}
    self.mappings["Tab"]["Other"].c             = {'Close Tab', c.cmd('tabclose'), {}}
    self.mappings["Tab"]["Other"].n             = {'New Tab', c.cmd('tabnew'), {}}
    self.mappings["Tab"]["Other"].q             = {'Quit', function() end, { exit = true }}

    -- Buffer Management -----------------------------------------------------------
    self.mappings["Buffer"]["Buffer Navigation"]['1'] = { 'First', c.cmd('bfirst'), {}}
    self.mappings["Buffer"]["Buffer Navigation"].h    = { 'Previous', c.cmd('bprev'),  {}}
    self.mappings["Buffer"]["Buffer Navigation"].l    = { 'Next', c.cmd('bnext'),  {}}
    self.mappings["Buffer"]["Buffer Navigation"]['9'] = { 'Last', c.cmd('blast'),  {}}
    self.mappings["Buffer"]["Other"].o                = { 'Delete Other Buffers', c.cmd('%bd|e#|bd#'), { exit = true }}
    self.mappings["Buffer"]["Other"].q                = { 'Quit', function() end, { exit = true }}

    -- Root Hydra ------------------------------------------------------------------
    self.mappings["Root"]["Vim"].b   = { 'Buffers',               function() M:runHydra("Buffer") end,        { exit = true } }
    self.mappings["Root"]["Vim"].t   = { 'Tabs',                  function() M:runHydra("Tab", false) end,    { exit = true } }
    self.mappings["Root"]["Vim"].w   = { 'Windows',               function() M:runHydra("Window", false) end, { exit = true } }
    self.mappings["Root"]["Other"].p = { 'Lazy (Plugin Manager)', c.cmd('Lazy'),                              { exit = true } }
    self.mappings["Root"]["Other"].q = { 'Quit',                  function() end,                             { exit = true } }

    -- We use a global export for this rather than returning from the module as it
    -- is difficult to thread the mappings table through various plugins, thus we
    -- instead just expose this in one place.
    _G.HydraMappings = self.mappings

    return self
end

-- We wrap the standard Hydra function to override some of the default how the
-- binding and window setup works.
function M:bindHydra(h)
    local hydra = require 'hydra'

    -- Before passing our `hints` options, we want to generate a pretty
    -- hint string and convert to the Hydra expected heads format from our
    -- Sectioned Table of Tables.
    local order = h.heads.__order or {}
    h.hint  = self.generateSingleColumn(order, h.heads)
    h.heads = self.flatten(h.heads)

    -- We can now create our hydra, and while we're at out we'll hijack the
    -- the `_make_win_config` method on the hydra hint object to ensure the
    -- window is always the full width of the screen.
    --
    -- NOTE: This makes some heavy assumptions about Hydra, but Hydra is a
    -- relatively complete plugin that doesn't see much churn, so we should
    -- be able to safely catch these changes.
    local h = hydra(h)

    function h.hint:_make_win_config()
        getmetatable(self)._make_win_config(self)
        self.win_config.height = vim.o.lines
        self.win_config.width  = 32
    end

    return h
end

function M:runHydra(name, buffer)
    M:bindHydra({
        name   = name,
        mode   = 'n',
        heads  = self.mappings[name],
        config = {
            hint   = self.hint_options,
            buffer = buffer == nil and true or buffer,
            on_key = function() vim.wait(50) end,
        },
    }):activate()
end


function M:bind()
    local hydra = require 'hydra'
    local c     = require 'hydra.keymap-util'
    vim.api.nvim_set_keymap('n', '<leader>', '', {
        noremap  = true,
        silent   = true,
        callback = function()
            M:runHydra('Root')
        end,
    })
end

function M.generate(headers, hints)
    -- Before we do anything else we need to iterate over the columns to find
    -- the longest column array length.
    local longest = 0
    for _, header in ipairs(headers) do
        local column = hints[header]
        local column_size = 0
        for _ in pairs(column) do
            column_size = column_size + 1
        end
        if column_size > longest then
            longest = column_size
        end
    end

    -- Add header to length.
    longest = longest + 4

    -- We start by iterating over the columns, we can render each column into a
    -- list of lines, this way when we have a list of lines for each column we
    -- can worry about concatenating them together line-wise.
    local columns = {}
    for _, header in ipairs(headers) do
        local column = hints[header]

        -- Make sure column is a table.
        if type(column) == 'table' then
            -- We can now iterate over the column and render each line, we keep
            -- track of the maximum width for this column so we can pad it out
            -- at the end. Note that we start with the length of the header as
            -- our initial largest width.
            local width  = #header
            local lines  = {}
            for key, hint in pairs(column) do
                local line = string.format('%s: %s', key, hint[1])
                width = math.max(width, #line)
                table.insert(lines, line)
            end

            -- Now sort the lines and prefix with the original header.
            table.sort(lines)
            table.insert(lines, 1, '')
            table.insert(lines, 1, header)
            table.insert(lines, 1, '')

            -- Now we know the longest column is stored in `column`, and we want
            -- to append empty lines to the end of the current column until it is
            -- the same length
            while #lines < longest do
                table.insert(lines, '')
            end

            -- We can now iterate over the lines and pad them out to the width
            -- of the now known widest column.
            for i, line in ipairs(lines) do
                lines[i] = line .. string.rep(' ', width - #line)
            end

            -- We can now add the column to the list of columns.
            table.insert(columns, lines)
        end
    end

    -- We can now iterate over the lines and concatenate them together. As all
    -- columns are the same length we can just use the length of the first
    -- column to count.
    local lines = {}
    for i = 1, #columns[1] do
        local line = {}
        for _, column in ipairs(columns) do
            if column[i] ~= nil then
                table.insert(line, column[i] .. '    ')
            end
        end
        table.insert(lines, '    ' .. table.concat(line) .. '\n')
    end

    -- Append an empty line.
    table.insert(lines, '')

    -- Now we concat the result, and we'll use regex to wrap all matches with
    -- `_` characters.
    local result = table.concat(lines)
    return result:gsub('([%w%^%$%(%)%%%.%[%]%*%+%-%?=/<>]+):', '_%1_ ')
end

function M.generateSingleColumn(headers, hints)
    local result = {}
    for _, header in ipairs(headers) do
        local lines  = {}
        local column = hints[header]

        -- Make sure column is a table.
        if type(column) == 'table' and header ~= '__order' and header ~= 'Other' then
            -- Now iterate over the column and render each line.
            for _, key in ipairs(column.__order) do
                local hint = column[key]
                if type(hint) == 'function' then
                    local hint = hint()
                    if hint ~= nil then
                        local line = string.format('  _%s_ %s', key, hint[1])
                        table.insert(lines, line)
                    end
                else
                    local line = string.format('  _%s_ %s', key, hint[1])
                    table.insert(lines, line)
                end
            end

            -- Sort the lines and insert them to the result.
            table.insert(lines, 1, '   ' .. header)
            table.insert(lines, '')
            for _, line in ipairs(lines) do
                table.insert(result, line)
            end
        end
    end

    -- Apply "Other" separately so it is always last.
    if vim.tbl_contains(headers, 'Other') then
        local lines  = {}
        local column = hints['Other']

        -- Now iterate over the column and render each line.
        for _, key in ipairs(column.__order) do
            local hint = column[key]
            -- If the hint bind is a function, and it doesn't return nil, then
            -- we can add it to the hint map.
            if type(hint) == 'function' then
                local hint = hint()
                if hint ~= nil then
                    local line = string.format('  _%s_ %s', key, hint[1])
                    table.insert(lines, line)
                end
            else
                local line = string.format('  _%s_ %s', key, hint[1])
                table.insert(lines, line)
            end
        end

        -- Sort the lines and insert them to the result.
        table.sort(lines)
        table.insert(lines, 1, '   Other')
        table.insert(lines, '')
        for _, line in ipairs(lines) do
            table.insert(result, line)
        end
    else
        local lines  = {'  _q_ Quit'}
        table.insert(lines, 1, '   Other')
        table.insert(lines, '')
        for _, line in ipairs(lines) do
            table.insert(result, line)
        end
    end

    -- Append an empty line.
    table.insert(result, '')

    -- Now we concat the result.
    local result = table.concat(result, '\n')
    return result
end

-- Flatten, when given a Sectioned Table of Tables indexed by keycodes:
--
-- ```
-- {
--    ['Some Section'] = {
--        ['<leader>'] = { 'Some Hint', function() end, {} },
--        'a'          = { 'Some Hint', function() end, {} },
--    }
--    ...
-- }
-- ```
--
-- Converts into a Hydra-compatible table:
--
-- ```
-- {
--    { '<leader>'],  function() end, {} },
--    { 'a',          function() end, {} },
--    ...
-- }
-- ```
function M.flatten(t)
    local result = {}
    for name, section in pairs(t) do
        -- Skip past the metatable managed __order.
        if name ~= "__order" then
            for keycode, hint in pairs(section) do
                if keycode ~= "__order" then
                    -- If `hint` is a function, then it is expected to return a
                    -- bind value, if it returns nil, we skip it.
                    if type(hint) == 'function' then
                        local bind = hint()
                        if bind ~= nil then
                            table.insert(result, { keycode, unpack(bind, 2) })
                        end
                    else
                        table.insert(result, { keycode, unpack(hint, 2) })
                    end
                end
            end
        end
    end

    -- Add `q` action if it doesn't exist.
    local has_q = false
    for _, hint in ipairs(result) do
        if hint[1] == 'q' then
            has_q = true
            break
        end
    end

    if not has_q then
        table.insert(result, { 'q', function() end, { exit = true } })
    end

    return result
end

return M
