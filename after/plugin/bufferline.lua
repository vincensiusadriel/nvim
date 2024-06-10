require('bufferline').setup {
    options = {
        mode = "buffers", -- set to "tabs" to only show tabpages instead
        numbers = "none",
        close_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
        right_mouse_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
        left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
        middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
        indicator = {
            icon = '▎', -- this should be omitted if indicator style is not 'icon'
            style = 'icon',
        },
        buffer_close_icon = 'x',
        modified_icon = '●',
        close_icon = '',
        max_name_length = 18,
        max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
        truncate_names = true,  -- whether or not tab names should be truncated
        tab_size = 18,
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = true,
        color_icons = false,
        show_buffer_icons = false, -- disable filetype icons for buffers
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        show_duplicate_prefix = false,
        persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
        -- can also be a table containing 2 custom separators
        -- [focused and unfocused]. eg: { '|', '|' }
    }
}

vim.keymap.set({ "n" }, "L", "<cmd>BufferLineCycleNext<cr>")
vim.keymap.set({ "n" }, "H", "<cmd>BufferLineCyclePrev<cr>")

local function buf_kill(kill_command, bufnr, force)
    kill_command = kill_command or "bd"

    local bo = vim.bo
    local api = vim.api
    local fmt = string.format
    local fnamemodify = vim.fn.fnamemodify

    if bufnr == 0 or bufnr == nil then
        bufnr = api.nvim_get_current_buf()
    end

    local bufname = api.nvim_buf_get_name(bufnr)

    if not force then
        local warning
        if bo[bufnr].modified then
            warning = fmt([[No write since last change for (%s)]], fnamemodify(bufname, ":t"))
        elseif api.nvim_buf_get_option(bufnr, "buftype") == "terminal" then
            warning = fmt([[Terminal %s will be killed]], bufname)
        end
        if warning then
            vim.ui.input({
                prompt = string.format([[%s. Close it anyway? [y]es or [n]o (default: no): ]], warning),
            }, function(choice)
                if choice:match "ye?s?" then force = true end
            end)
            if not force then return end
        end
    end

    -- Get list of windows IDs with the buffer to close
    local windows = vim.tbl_filter(function(win)
        return api.nvim_win_get_buf(win) == bufnr
    end, api.nvim_list_wins())

    if force then
        kill_command = kill_command .. "!"
    end

    -- Get list of active buffers
    local buffers = vim.tbl_filter(function(buf)
        return api.nvim_buf_is_valid(buf) and bo[buf].buflisted
    end, api.nvim_list_bufs())

    -- If there is only one buffer (which has to be the current one), vim will
    -- create a new buffer on :bd.
    -- For more than one buffer, pick the previous buffer (wrapping around if necessary)
    if #buffers > 1 and #windows > 0 then
        for i, v in ipairs(buffers) do
            if v == bufnr then
                local prev_buf_idx = i == 1 and (#buffers - 1) or (i - 1)
                local prev_buffer = buffers[prev_buf_idx]
                for _, win in ipairs(windows) do
                    api.nvim_win_set_buf(win, prev_buffer)
                end
            end
        end
    end

    -- Check if buffer still exists, to ensure the target buffer wasn't killed
    -- due to options like bufhidden=wipe.
    if api.nvim_buf_is_valid(bufnr) and bo[bufnr].buflisted then
        vim.cmd(string.format("%s %d", kill_command, bufnr))
    end
end

vim.api.nvim_create_user_command("BufferKill", function()
    buf_kill "bd"
end, { force = true })
