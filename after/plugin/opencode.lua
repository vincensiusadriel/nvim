---@type opencode.Opts
vim.g.opencode_opts = {
    -- Your configuration, if any; goto definition on the type for details
}

-- Recommended/example keymaps
vim.keymap.set({ "n", "x" }, "<leader>oa", function() require("opencode").ask("@this: ") end,
    { desc = "Ask OpenCode…" })
vim.keymap.set({ "n", "x" }, "<leader>ox", function() require("opencode").select() end,
    { desc = "Select OpenCode…" })

local opencode_cmd = "opencode --port"
-- local opencode_cmd = "ttadk code" --bytedance adk
local opencode_pane_id = nil
local opencode_visible = false

--- Find an opencode pane in tmux (tagged @opencode or running the opencode cmd)
local function find_opencode_pane()
    local out = vim.fn.system("tmux list-panes -a -F '#{pane_id}|#{@opencode}|#{pane_current_command}'")
    for line in vim.gsplit(out, "\n", { plain = true }) do
        local id, tag, cmd = line:match("^([^|]+)|([^|]*)|([^|]*)$")
        if id and id ~= "" and (tag == "1" or cmd == "opencode") then
            return vim.trim(id)
        end
    end
    return nil
end

local function pane_window_id(pane_id)
    local out = vim.fn.system(
        "tmux display-message -p -t " .. vim.fn.shellescape(pane_id) .. " '#{window_id}' 2>/dev/null")
    if vim.v.shell_error ~= 0 or vim.trim(out) == "" then
        return nil
    end
    return vim.trim(out)
end

--- Check tracked pane still exists; rediscover from tmux if tracking was lost
local function pane_exists()
    if opencode_pane_id then
        local out = vim.fn.system(
            "tmux display-message -p -t " .. vim.fn.shellescape(opencode_pane_id) .. " '#{pane_id}' 2>/dev/null")
        if vim.v.shell_error == 0 and vim.trim(out) == opencode_pane_id then
            return true
        end
        opencode_pane_id = nil
        opencode_visible = false
    end

    local found = find_opencode_pane()
    if not found then
        opencode_visible = false
        return false
    end
    opencode_pane_id = found

    local oc_win = pane_window_id(found)
    local nvim_win = vim.env.TMUX_PANE and pane_window_id(vim.env.TMUX_PANE) or nil
    opencode_visible = oc_win ~= nil and oc_win == nvim_win
    return true
end

local function start()
    if pane_exists() and opencode_visible then
        return
    end
    if pane_exists() then
        -- Restore hidden pane back into the current window
        vim.fn.system("tmux join-pane -h -l 40% -s " .. opencode_pane_id)
    else
        -- Create a new tmux pane and capture its ID
        local result = vim.fn.system("tmux split-window -h -l 40% -P -F '#{pane_id}' " ..
            vim.fn.shellescape(opencode_cmd))
        opencode_pane_id = vim.trim(result)
        if opencode_pane_id ~= "" then
            -- Tag pane so it can be rediscovered after nvim restart
            vim.fn.system("tmux set -p -t " .. vim.fn.shellescape(opencode_pane_id) .. " @opencode 1")
        end
        -- Return focus to the Neovim pane
        vim.fn.system("tmux select-pane -l")
    end
    opencode_visible = true
end

local function stop()
    if not pane_exists() then
        return
    end
    vim.fn.system("tmux send-keys -t " .. opencode_pane_id .. " C-c")
    vim.defer_fn(function()
        vim.fn.system("tmux kill-pane -t " .. opencode_pane_id)
        opencode_pane_id = nil
        opencode_visible = false
    end, 500)
end

vim.keymap.set({ "n", "t" }, "<leader>ot", function() start() end,
    { desc = "Open OpenCode" })

-- Clean up hidden pane on Neovim exit
-- vim.api.nvim_create_autocmd("VimLeavePre", {
--     callback = function()
--         if pane_exists() then
--             vim.fn.system("tmux kill-pane -t " .. opencode_pane_id)
--         end
--     end,
-- })

---@type opencode.Opts
vim.g.opencode_opts = {
    server = {
        start = start,
    },
}

-- Required for `opts.events.reload`.
vim.o.autoread = true


-- vim.keymap.set({ "n", "x" }, "go", function() return require("opencode").operator("@this") end,
--     { desc = "Send range to OpenCode", expr = true })
-- vim.keymap.set({ "n" }, "goo", function() return require("opencode").operator("@this") .. "_" end,
--     { desc = "Send line to OpenCode", expr = true })

-- PREVIOUS CONFIG with TMUX
-- {
--     "NickvanDyke/opencode.nvim",
--     dependencies = {
--         -- Recommended for `ask()` and `select()`.
--         ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
--         {
--             "folke/snacks.nvim",
--             lazy = false,
--             priority = 1000,
--             opts = { input = {}, picker = {}, terminal = {} },
--         },
--     },
--     keys = {
--         { "<leader>oa",  function() require("opencode").ask("@this: ", { submit = true }) end, mode = { "n", "x" }, desc = "Ask opencode" },
--         { "<leader>op",  function() require("opencode").ask("", { submit = true }) end,        mode = { "n", "x" }, desc = "Prompt opencode" },
--         { "<leader>ox",  function() require("opencode").select() end,                          mode = { "n", "x" }, desc = "Execute opencode action" },
--         { "<leader>ot",  function() require("opencode").toggle() end,                          mode = { "n", "t" }, desc = "Toggle opencode" },
--         { "<leader>ocr", function() return require("opencode").operator("@this ") end,         mode = { "n", "x" }, expr = true,                     desc = "Concat range to opencode" },
--         { "<leader>ocl", function() return require("opencode").operator("@this ") .. "_" end,  mode = "n",          expr = true,                     desc = "Concat line to opencode" },
--         { "<leader>ou",  function() require("opencode").command("session.half.page.up") end,   mode = "n",          desc = "Opencode half page up" },
--         { "<leader>od",  function() require("opencode").command("session.half.page.down") end, mode = "n",          desc = "Opencode half page down" },
--         { "<leader>on",  function() require("opencode").command("agent.cycle") end,            mode = "n",          desc = "Cycle opencode agent" },
--         {
--             "<leader>ocs",
--             function()
--                 local mode = vim.fn.mode()
--                 vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", true)

--                 vim.schedule(function()
--                     local start_pos = vim.fn.getpos("'<")
--                     local end_pos = vim.fn.getpos("'>")
--                     local lines = vim.fn.getregion(start_pos, end_pos, { type = mode })
--                     local text = table.concat(lines, "\n")

--                     require("opencode").prompt(text, { submit = false })
--                 end)
--             end,
--             mode = "x",
--             desc = "Concat selection to opencode"
--         },
--     },
--     config = function()
--     end,
-- },
