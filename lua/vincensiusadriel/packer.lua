-- Install packer
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

local plugins = {
    {
        'junegunn/fzf',
        build = ":call fzf#install()"
    },
    {
        'nvim-telescope/telescope.nvim',
        version = '*',
        -- or                            , branch = '0.1.x',
        dependencies = { { 'nvim-lua/plenary.nvim' }, { "kdheepak/lazygit.nvim" } }
    },
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main", -- Ensure this is set to main
        build = ":TSUpdate",
    },
    {
        'bluz71/vim-moonfly-colors',
        name = "moonfly",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd [[colorscheme moonfly]]
        end
    },
    'mbbill/undotree',
    'tpope/vim-fugitive',
    -- { 'folke/tokyonight.nvim' },

    -- LSP setup
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            -- LSP Support
            {
                'williamboman/mason.nvim',
                build = function()
                    pcall(vim.cmd, 'MasonUpdate')
                end,
            },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'hrsh7th/cmp-cmdline' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        }
    },

    {
        "ray-x/go.nvim",
        dependencies = { -- optional packages
            "ray-x/guihua.lua",
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
        end,
        event = { "CmdlineEnter" },
        ft = { "go", 'gomod' },
        build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
    },
    -- { 'fatih/vim-go',                     build = ':GoUpdateBinaries', },
    -- { "akinsho/toggleterm.nvim", version = '*', config = function()
    --     require("toggleterm").setup()
    -- end }
    {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    },
    {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end
    },
    {
        'nvim-tree/nvim-tree.lua',
    },
    { 'lewis6991/gitsigns.nvim', version = 'v0.6' },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons', lazy = true }
    },
    { 'akinsho/bufferline.nvim', version = "*",   dependencies = 'nvim-tree/nvim-web-devicons' },
    'nvim-treesitter/nvim-treesitter-context',
    'simrat39/symbols-outline.nvim',
    {
        'vincensiusadriel/hop.nvim',
        branch = 'master', -- optional but strongly recommended
    },
    "tpope/vim-surround",
    "christoomey/vim-tmux-navigator",
    "ThePrimeagen/harpoon",
    "ray-x/lsp_signature.nvim",
    -- codeverse integration
    -- {
    --     "https://code.byted.org/chenjiaqi.cposture/codeverse.vim.git",
    --     dependencies = {
    --         "hrsh7th/nvim-cmp",
    --     },
    --     config = function()
    --         require("codeverse").setup({
    --         })
    --     end
    -- }
    -- MD integration
    {
        -- markdown preview from nvim
        'iamcco/markdown-preview.nvim',
        cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
        ft = { 'markdown' },
        build = function()
            vim.fn['mkdp#util#install']()
        end,
    },
    -- {
    --     "nickjvandyke/opencode.nvim",
    --     version = "*", -- Latest stable release
    --     dependencies = {
    --         {
    --             -- `snacks.nvim` integration is recommended, but optional
    --             ---@module "snacks" <- Loads `snacks.nvim` types for configuration intellisense
    --             "folke/snacks.nvim",
    --             optional = true,
    --             opts = {
    --                 input = {}, -- Enhances `ask()`
    --                 picker = {  -- Enhances `select()`
    --                     actions = {
    --                         opencode_send = function(...) return require("opencode").snacks_picker_send(...) end,
    --                     },
    --                     win = {
    --                         input = {
    --                             keys = {
    --                                 ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
    --                             },
    --                         },
    --                     },
    --                 },
    --             },
    --         },
    --     },
    --     config = function()
    --         ---@type opencode.Opts
    --         vim.g.opencode_opts = {
    --             -- Your configuration, if any; goto definition on the type or field for details
    --         }

    --         vim.o.autoread = true -- Required for `opts.events.reload`

    --         -- Recommended/example keymaps
    --         vim.keymap.set({ "n", "x" }, "<leader>oa",
    --             function() require("opencode").ask("@this: ", { submit = true }) end,
    --             { desc = "Ask opencode…" })
    --         vim.keymap.set({ "n", "x" }, "<leader>ox", function() require("opencode").select() end,
    --             { desc = "Execute opencode action…" })
    --         vim.keymap.set({ "n", "t" }, "<leader>ot", function() require("opencode").toggle() end,
    --             { desc = "Toggle opencode" })

    --         vim.keymap.set({ "n", "x" }, "<leader>oo", function() return require("opencode").operator("@this ") end,
    --             { desc = "Add range to opencode", expr = true })
    --         vim.keymap.set("n", "<leader>ooo", function() return require("opencode").operator("@this ") .. "_" end,
    --             { desc = "Add line to opencode", expr = true })
    --     end,
    -- }
}

local opts = {}

-- Compatibility shim for Nvim 0.12 — plugins still use the deprecated vim.lsp.buf_get_clients(bufnr)
vim.lsp.buf_get_clients = function(bufnr)
    return vim.lsp.get_clients({ bufnr = bufnr or 0 })
end

-- Nvim 0.12 compat: vim.treesitter.ft_to_lang removed, use language.get_lang instead

require("lazy").setup(plugins, opts)
