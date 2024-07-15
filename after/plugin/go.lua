local format_sync_grp = vim.api.nvim_create_augroup("goimports", {})
-- vim.api.nvim_create_autocmd("BufWritePre", {
--     pattern = "*.go",
--     callback = function()
--         require('go.format').goimports()
--     end,
--     group = format_sync_grp,
-- })

require('go').setup({
    tag_options = '', -- sets options sent to gomodifytags, i.e., json=omitempty
    luasnip = true,
})
