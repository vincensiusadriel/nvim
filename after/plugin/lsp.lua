local lsp = require('lsp-zero')
lsp.preset('recommended')

lsp.ensure_installed({
    -- 'tsserver',
    -- 'eslint',
    'rust_analyzer',
    -- 'kotlin_language_server',
    -- 'jdtls',
    'lua_ls',
    -- 'jsonls',
    -- 'html',
    'elixirls',
    -- 'tailwindcss',
    'tflint',
    'pylsp',
    -- 'dockerls',
    -- 'bashls',
    -- 'marksman',
})

local cmp = require('cmp')
local luasnip = require('luasnip')
local cmp_select = { behavior = cmp.SelectBehavior.Select }

-- ultisnip
local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<Tab>"] = cmp.mapping(
        function(fallback)
            if cmp.visible() then
                cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
            else
                if luasnip.expand_or_locally_jumpable() then
                    luasnip.jump(1)
                else
                    cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
                end
            end
        end,
        { "i", "s", --[[ "c" (to enable the mapping in command mode) ]] }
    ),
    ["<S-Tab>"] = cmp.mapping(
        function(fallback)
            if cmp.visible() then
                cmp_ultisnips_mappings.jump_backwards(fallback)
            else
                if luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    cmp_ultisnips_mappings.jump_backwards(fallback)
                end
            end
        end,
        { "i", "s", --[[ "c" (to enable the mapping in command mode) ]] }
    ),
})

-- disable completion with tab
-- this helps with copilot setup
-- cmp_mappings['<Tab>'] = nil
-- cmp_mappings['<S-Tab>'] = nil

local sources = {
    { name = "ultisnips" },
    { name = "luasnip" },
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'buffer' },
}

lsp.setup_nvim_cmp({
    mapping = cmp_mappings,
    sources = sources,
    snippet = {
        expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body)
        end,
    },
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    if client.name == "eslint" then
        vim.cmd.LspStop('eslint')
        return
    end

    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<leader>h", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
    vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
end)

lsp.setup()

vim.diagnostic.config({
    virtual_text = true,
    update_in_insert = true,
})

-- add format on save
vim.api.nvim_create_augroup("lsp_format_on_save", {})
vim.api.nvim_create_autocmd("BufWritePre", {
    group = "lsp_format_on_save",
    pattern = "*",
    callback = function()
        vim.lsp.buf.format()
    end,
})


-- `/` cmdline setup.
-- ref : https://github.com/hrsh7th/nvim-cmp/issues/875
cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(), -- important!
    sources = {
        { name = 'buffer' }
    }
})
-- -- `:` cmdline setup.
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        {
            name = 'cmdline',
            option = {
                ignore_cmds = { 'Man', '!' }
            }
        }
    })
})


local cmp_action = require('lsp-zero').cmp_action()
cmp.setup({
    sources = sources,
    -- mapping = {
    --     ['<C-f>'] = cmp_action.luasnip_jump_forward(),
    --     ['<C-b>'] = cmp_action.luasnip_jump_backward(),
    --     ['<Tab>'] = cmp_action.luasnip_supertab(),
    --     ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
    -- },
})
