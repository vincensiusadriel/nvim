require("symbols-outline").setup({
    show_symbol_details = true
})

vim.keymap.set('n', '<leader>a', ":SymbolsOutline<cr>", {})
