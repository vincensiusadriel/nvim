local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>f', builtin.find_files, {})

vim.keymap.set('n', '<C-p>', function()
    local ok = pcall(builtin.git_files, {})

    if not ok then
        builtin.find_files()
    end
end, {})


require("telescope").load_extension("lazygit")

vim.keymap.set('n', '<leader>gg', ":LazyGit<cr>", {})
vim.keymap.set('n', '<leader>st', builtin.live_grep, {})
vim.keymap.set('n', '<C-g>', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)

vim.api.nvim_set_hl(0, "TelescopeBorder", { ctermbg = "none" })
