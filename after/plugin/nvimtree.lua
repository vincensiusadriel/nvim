-- examples for your init.lua

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()

-- OR setup with some options
require("nvim-tree").setup({
    sort_by = "case_sensitive",
    view = {
        adaptive_size = true,
        mappings = {
            list = {
                { key = "u", action = "dir_up" },
            },
        },
    },
    renderer = {
        add_trailing = false,
        group_empty = false,
        highlight_git = false,
        full_name = false,
        highlight_opened_files = "none",
        root_folder_label = ":~:s?$?/..?",
        indent_width = 2,
        indent_markers = {
            enable = false,
            inline_arrows = true,
            icons = {
                corner = "└",
                edge = "│",
                item = "│",
                bottom = "─",
                none = " ",
            },
        },
        icons = {
            webdev_colors = true,
            git_placement = "before",
            padding = " ",
            symlink_arrow = " ➛ ",
            show = {
                file = false,
                folder = true,
                folder_arrow = true,
                git = true,
            },
            glyphs = {
                default = "❏",
                symlink = " ➛ ",
                bookmark = "★",
                folder = {
                    arrow_closed = "►",
                    arrow_open = "▼",
                    default = "",
                    open = "",
                    empty = "",
                    empty_open = "",
                    symlink = "➱",
                    symlink_open = "➮",
                },
                git = {
                    unstaged = "U",
                    staged = "S",
                    unmerged = "UM",
                    renamed = "➜",
                    untracked = "UT",
                    deleted = "✗",
                    ignored = "◌",
                },
            },
        },
        special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
        symlink_destination = true,
    },
    filters = {
        dotfiles = true,
    },
    diagnostics = {
        enable = true,
        show_on_dirs = false,
        show_on_open_dirs = true,
        debounce_delay = 50,
        severity = {
            min = vim.diagnostic.severity.HINT,
            max = vim.diagnostic.severity.ERROR,
        },
        icons = {
            hint = "H",
            info = "I",
            warning = "W",
            error = "E",
        },
    },
    update_focused_file = {
        enable = true,
        debounce_delay = 15,
        update_root = false,
        ignore_list = {},
    }
})
