-- Install packer
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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
        version = '0.1.4',
        -- or                            , branch = '0.1.x',
        dependencies = { { 'nvim-lua/plenary.nvim' }, { "kdheepak/lazygit.nvim" } }
    },
    {
        "nvim-treesitter/nvim-treesitter",
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
    'nvim-treesitter/playground',
    'mbbill/undotree',
    'tpope/vim-fugitive',


    -- ultisnips setup
    {
        'VonHeikemen/lsp-zero.nvim',
        dependencies = {
            -- LSP Support
            {
                'williamboman/mason.nvim',
                build = function()
                    pcall(vim.cmd, 'MasonUpdate')
                end,
            },
            { 'williamboman/mason-lspconfig.nvim' },
            { 'neovim/nvim-lspconfig' },

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
            { 'SirVer/ultisnips' },
            { 'quangnguyen30192/cmp-nvim-ultisnips' },
        }
    },
    { 'fatih/vim-go',            build = ':GoUpdateBinaries', },
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
    { 'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons' },
    'nvim-treesitter/nvim-treesitter-context',
    'simrat39/symbols-outline.nvim',
    {
        'phaazon/hop.nvim',
        branch = 'v2', -- optional but strongly recommended
    },
    "tpope/vim-surround",
    "christoomey/vim-tmux-navigator",
    "ThePrimeagen/harpoon",
    "ray-x/lsp_signature.nvim",

}

local opts = {}


require("lazy").setup(plugins, opts)
