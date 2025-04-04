require 'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all"
    ensure_installed = {
        -- "vim", "go", "typescript", "javascript", "c", "cpp", "rust", "lua", "vimdoc"
        "bash",
        "c",
        "cpp",
        "css",
        "go",
        "javascript",
        "json",
        "lua",
        "query",
        "rust",
        "templ",
        "thrift",
        "typescript",
        "vim",
        "vimdoc",
        "vue",
    },
    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = true,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = false,

    ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
    -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

    highlight = {
        -- `false` will disable the whole extension
        enable = true,


        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
}

vim.cmd("TSDisable highlight")

vim.cmd([[
augroup enable_tshighlight
    autocmd!
    autocmd VimEnter * TSEnable highlight
augroup END
]])
-- vim.cmd("TSEnable highlight")

require 'treesitter-context'.setup {
    enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
    max_lines = 5, -- How many lines the window should span. Values <= 0 mean no limit.
}
