require 'nvim-treesitter.config'.setup {
    sync_install = true,
    auto_install = false,
}

require('nvim-treesitter').install {
    "bash", "c", "cpp", "css", "go", "javascript", "json",
    "lua", "query", "rust", "templ", "thrift",
    "typescript", "vim", "vimdoc", "vue",
}

-- Nvim 0.12 uses vim.treesitter.start() per buffer instead of nvim-treesitter's old highlight module
vim.api.nvim_create_autocmd('FileType', {
    callback = function(ev)
        pcall(vim.treesitter.start, ev.buf)
    end,
})

require 'treesitter-context'.setup {
    enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
    max_lines = 5, -- How many lines the window should span. Values <= 0 mean no limit.
}
