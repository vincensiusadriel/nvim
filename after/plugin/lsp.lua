local cmp = require('cmp')
local cmp_nvim_lsp = require('cmp_nvim_lsp')
local luasnip = require('luasnip')

local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
    ['<Tab>'] = cmp.mapping(function(fallback)
        if luasnip.jumpable(1) then
            luasnip.jump(1)
            return
        end

        fallback()
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
        if luasnip.jumpable(-1) then
            luasnip.jump(-1)
            return
        end

        fallback()
    end, { 'i', 's' }),
})

-- disable completion with tab
-- this helps with copilot setup
-- cmp_mappings['<Tab>'] = nil
-- cmp_mappings['<S-Tab>'] = nil

local sources = {
    -- { name = "codeverse" },
    { name = 'nvim_lsp' },
    { name = "luasnip" },
    { name = 'path' },
    { name = 'buffer' },
}

require('luasnip.loaders.from_vscode').lazy_load()

local capabilities = cmp_nvim_lsp.default_capabilities()

cmp.setup({
    mapping = cmp_mappings,
    sources = sources,
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
})

for type, icon in pairs({ error = 'E', warn = 'W', hint = 'H', info = 'I' }) do
    local hl = 'DiagnosticSign' .. type:sub(1, 1):upper() .. type:sub(2)
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
end

local lsp_attach_group = vim.api.nvim_create_augroup('user_lsp_attach', { clear = true })
vim.api.nvim_create_autocmd('LspAttach', {
    group = lsp_attach_group,
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if not client then
            return
        end

        if client.name == 'eslint' then
            vim.schedule(function()
                vim.lsp.stop_client(client.id)
            end)
            return
        end

        local opts = { buffer = event.buf, remap = false }

        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<leader>vws', vim.lsp.buf.workspace_symbol, opts)
        vim.keymap.set('n', '<leader>vd', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_next, opts)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        -- vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, opts)
    end,
})

vim.diagnostic.config({
    virtual_text = true,
    update_in_insert = true,
})

-- add format on save
vim.api.nvim_create_autocmd('BufWritePre', {
    group = vim.api.nvim_create_augroup('lsp_format_on_save', { clear = true }),
    pattern = '*',
    callback = function(args)
        vim.lsp.buf.format({ bufnr = args.buf })
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

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {
        'bashls',
        'cssls',
        'css_variables',
        'cssmodules_ls',
        'elixirls',
        -- 'gci',
        -- 'gofumpt',
        -- 'goimports',
        -- 'golangci-lint',
        -- 'golines',
        -- 'gomodifytags',
        'gopls',
        -- 'gotests',
        -- 'gotestsum',
        'html',
        -- 'htmlhint',
        -- 'htmx',
        'lua_ls',
        -- 'pylsp',
        'quick_lint_js',
        'rust_analyzer',
        -- 'shfmt',
        'tailwindcss',
        'templ',
        'tflint',
        'thriftls',
        'ts_ls',
        'vue_ls',
        -- 'yamlfmt',
        -- 'yamllint',
        'emmet_ls',
    },
    automatic_enable = false,
})

local mason_settings = require('mason.settings')
local vue_language_server_path = vim.fs.joinpath(
    mason_settings.current.install_root_dir,
    'packages',
    'vue-language-server',
    'node_modules',
    '@vue',
    'language-server'
)

vim.filetype.add({ extension = { templ = 'templ' } })

vim.lsp.config('*', {
    capabilities = capabilities,
})

vim.lsp.config('ts_ls', {
    init_options = {
        hostInfo = 'neovim',
        plugins = {
            {
                name = '@vue/typescript-plugin',
                location = vue_language_server_path,
                languages = { 'vue' },
            },
        },
    },
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
})

-- vim.lsp.config('htmx', {
--     filetypes = { 'html', 'templ' },
-- })

vim.lsp.config('emmet_ls', {
    filetypes = { 'templ', 'css', 'eruby', 'html', 'javascript', 'javascriptreact', 'less', 'sass', 'scss', 'svelte', 'pug', 'typescriptreact', 'vue' },
    init_options = {
        html = {
            options = {
                -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
                ["bem.enabled"] = true,
            },
        },
    }
})

vim.lsp.enable({
    'bashls',
    'cssls',
    'css_variables',
    'cssmodules_ls',
    'elixirls',
    'gopls',
    'html',
    -- 'htmx',
    'lua_ls',
    -- 'pylsp',
    'quick_lint_js',
    'rust_analyzer',
    'tailwindcss',
    'templ',
    'tflint',
    'thriftls',
    'ts_ls',
    'vue_ls',
    'emmet_ls',
})
