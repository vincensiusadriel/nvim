vim.g.mapleader = " "
local function termcodes(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<cr>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])
vim.keymap.set({ "n", "v" }, "<leader>D", [["_D]])
vim.keymap.set({ "n", "v" }, "<leader>c", [["_c]])
vim.keymap.set({ "n", "v" }, "<leader>C", [["_C]])

vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format)


-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
-- vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
-- vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- vim.keymap.set("n", "<C-j>", "<C-w>j")
-- vim.keymap.set("n", "<C-h>", "<C-w>h")
-- vim.keymap.set("n", "<C-k>", "<C-w>k")
-- vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-j>", ":<C-u>TmuxNavigateDown<cr>")
vim.keymap.set("n", "<C-h>", ":<C-u>TmuxNavigateLeft<cr>")
vim.keymap.set("n", "<C-k>", ":<C-u>TmuxNavigateUp<cr>")
vim.keymap.set("n", "<C-l>", ":<C-u>TmuxNavigateRight<cr>")
vim.keymap.set({ "n", "v" }, "<leader><Esc>", "<cmd>BufferKill<cr>")
vim.keymap.set("t", "<leader><Esc>", termcodes "<C-\\><C-N>")



if vim.fn.has "mac" == 1 or vim.fn.has "macunix" == 1 then
    vim.keymap.set("n", "<A-Up>", ":resize +2<CR>")
    vim.keymap.set("n", "<A-Down>", ":resize -2<CR>")
    vim.keymap.set("n", "<A-Left>", ":vertical resize -2<CR>")
    vim.keymap.set("n", "<A-Right>", ":vertical resize +2<CR>")
else
    vim.keymap.set("n", "<C-Up>", ":resize +2<CR>")
    vim.keymap.set("n", "<C-Down>", ":resize -2<CR>")
    vim.keymap.set("n", "<C-Left>", ":vertical resize +2<CR>")
    vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>")
end

vim.keymap.set("n", "<leader>/", "<Plug>(comment_toggle_linewise_current)")
vim.keymap.set("v", "<leader>/", "<Plug>(comment_toggle_linewise_visual)")

-- replace mapping
vim.keymap.set("n", "<leader>rs", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set({ "n", "v" }, "<leader>rk", ":s/\\(.*\\)/\\1")


vim.keymap.set("t", "<C-j>", "<C-\\><C-N><C-w>h")
vim.keymap.set("t", "<C-h>", "<C-\\><C-N><C-w>j")
vim.keymap.set("t", "<C-k>", "<C-\\><C-N><C-w>k")
vim.keymap.set("t", "<C-l>", "<C-\\><C-N><C-w>l")

vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww ~/tmux-sessionizer<CR>")


vim.keymap.set("n", "<leader>t", ":let $VIM_DIR=expand('%:p:h')<CR>:terminal<CR>Acd $VIM_DIR<CR>")


vim.keymap.set("n", "d", "\"_d")
vim.keymap.set("v", "d", "\"_d")
vim.keymap.set("n", "c", "\"_c")
vim.keymap.set("v", "c", "\"_c")
vim.keymap.set("v", "p", "\"_c<C-r><C-o>+<Esc>")

vim.keymap.set("n", "<leader>n", ":tabnew<CR>")

-- stay indent mode
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")


vim.keymap.set("n", "<leader>j", ":cnext<CR>")
vim.keymap.set("n", "<leader>h", ":colder<CR>")
vim.keymap.set("n", "<leader>k", ":cprev<CR>")
vim.keymap.set("n", "<leader>l", ":cnewer<CR>")
vim.keymap.set("n", "<leader>o", ":copen<CR>")
vim.keymap.set("n", "<leader>c", ":cclose<CR>")


-- codeverse
-- vim.keymap.set('i', '<C-]>', '<Plug>(codeverse-next-or-complete)', { noremap = false, silent = true })

vim.api.nvim_create_user_command('GoCover', function()
    vim.cmd('GoCoverage -p')
end, {})


-- Function to toggle Quickfix list
function ToggleQuickfix()
    local quickfix_open = false
    for _, win in ipairs(vim.fn.getwininfo()) do
        if win.quickfix == 1 then
            quickfix_open = true
            break
        end
    end

    if quickfix_open then
        vim.cmd('cclose') -- Close the Quickfix list
    else
        vim.cmd('copen')  -- Open the Quickfix list
    end
end

-- Map the function to a key (e.g., <leader>q)
vim.keymap.set('n', '<leader>q', ToggleQuickfix, { noremap = true, silent = true })
