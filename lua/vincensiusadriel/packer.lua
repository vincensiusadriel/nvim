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
    {
        "NickvanDyke/opencode.nvim",
        dependencies = {
            -- Recommended for `ask()` and `select()`.
            ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
            {
                "folke/snacks.nvim",
                lazy = false,
                priority = 1000,
                opts = { input = {}, picker = {}, terminal = {} },
            },
        },
        keys = {
            { "<leader>oa",  function() require("opencode").ask("@this: ", { submit = true }) end, mode = { "n", "x" }, desc = "Ask opencode" },
            { "<leader>op",  function() require("opencode").ask("", { submit = true }) end,        mode = { "n", "x" }, desc = "Prompt opencode" },
            { "<leader>ox",  function() require("opencode").select() end,                          mode = { "n", "x" }, desc = "Execute opencode action" },
            { "<leader>ot",  function() require("opencode").toggle() end,                          mode = { "n", "t" }, desc = "Toggle opencode" },
            { "<leader>ocr", function() return require("opencode").operator("@this ") end,         mode = { "n", "x" }, expr = true,                     desc = "Concat range to opencode" },
            { "<leader>ocl", function() return require("opencode").operator("@this ") .. "_" end,  mode = "n",          expr = true,                     desc = "Concat line to opencode" },
            { "<leader>ou",  function() require("opencode").command("session.half.page.up") end,   mode = "n",          desc = "Opencode half page up" },
            { "<leader>od",  function() require("opencode").command("session.half.page.down") end, mode = "n",          desc = "Opencode half page down" },
            { "<leader>on",  function() require("opencode").command("agent.cycle") end,            mode = "n",          desc = "Cycle opencode agent" },
            {
                "<leader>ocs",
                function()
                    local mode = vim.fn.mode()
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", true)

                    vim.schedule(function()
                        local start_pos = vim.fn.getpos("'<")
                        local end_pos = vim.fn.getpos("'>")
                        local lines = vim.fn.getregion(start_pos, end_pos, { type = mode })
                        local text = table.concat(lines, "\n")

                        require("opencode").prompt(text, { submit = false })
                    end)
                end,
                mode = "x",
                desc = "Concat selection to opencode"
            },
        },
        config = function()
            local opencode_cmd = "opencode --port"
            -- local opencode_cmd = "ttadk code" --bytedance adk
            local opencode_pane_id = nil
            local opencode_visible = false

            --- Check if tracked pane still exists in tmux
            local function pane_exists()
                if not opencode_pane_id then
                    return false
                end
                local check = vim.fn.system("tmux has-session -t " .. opencode_pane_id .. " 2>/dev/null; echo $?")
                if vim.trim(check) == "0" then
                    return true
                end
                opencode_pane_id = nil
                opencode_visible = false
                return false
            end

            local function start()
                if pane_exists() and opencode_visible then
                    return
                end
                if pane_exists() then
                    -- Restore hidden pane back into the current window
                    vim.fn.system("tmux join-pane -h -l 35% -s " .. opencode_pane_id)
                else
                    -- Create a new tmux pane and capture its ID
                    local result = vim.fn.system("tmux split-window -h -l 35% -P -F '#{pane_id}' " ..
                        vim.fn.shellescape(opencode_cmd))
                    opencode_pane_id = vim.trim(result)
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

            local function toggle()
                if not pane_exists() then
                    start()
                elseif opencode_visible then
                    -- Hide pane without killing it (preserves opencode session)
                    vim.fn.system("tmux break-pane -d -s " .. opencode_pane_id)
                    opencode_visible = false
                else
                    -- Restore hidden pane
                    vim.fn.system("tmux join-pane -h -l 35% -s " .. opencode_pane_id)
                    opencode_visible = true
                end
            end

            -- Clean up hidden pane on Neovim exit
            vim.api.nvim_create_autocmd("VimLeavePre", {
                callback = function()
                    if pane_exists() then
                        vim.fn.system("tmux kill-pane -t " .. opencode_pane_id)
                    end
                end,
            })

            ---@type opencode.Opts
            vim.g.opencode_opts = {
                server = {
                    start = start,
                    stop = stop,
                    toggle = toggle,
                },
            }

            -- Required for `opts.events.reload`.
            vim.o.autoread = true
        end,
    },
}

local opts = {}

-- Compatibility shim for Nvim 0.12 — plugins still use the deprecated vim.lsp.buf_get_clients(bufnr)
vim.lsp.buf_get_clients = function(bufnr)
    return vim.lsp.get_clients({ bufnr = bufnr or 0 })
end

-- Nvim 0.12 compat: vim.treesitter.ft_to_lang removed, use language.get_lang instead

require("lazy").setup(plugins, opts)
