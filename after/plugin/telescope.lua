local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>f', builtin.find_files, {})

vim.keymap.set('n', '<C-p>', function()
	local ok = pcall(builtin.git_files, {})

	if not ok then
		builtin.find_files()
	end
end, {})

vim.keymap.set('n', '<C-f>', function()
	builtin.grep_string({search = vim.fn.input("Grep > ")})
end)

-- vim.keymap.set('n', '<leader>st', builtin.live_grep, {})
