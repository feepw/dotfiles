require('config.global').init()
require 'config.option'
require 'config.plugin'

-- KEYMAPS
--
-- See `:h vim.keymap.set()`, `:h mapping`, `:h keycodes`

-- Use <Esc> to exit terminal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- -- Map <A-j>, <A-k>, <A-h>, <A-l> to navigate between windows in any modes
-- vim.keymap.set({ 't', 'i' }, '<A-h>', '<C-\\><C-n><C-w>h')
-- vim.keymap.set({ 't', 'i' }, '<A-j>', '<C-\\><C-n><C-w>j')
-- vim.keymap.set({ 't', 'i' }, '<A-k>', '<C-\\><C-n><C-w>k')
-- vim.keymap.set({ 't', 'i' }, '<A-l>', '<C-\\><C-n><C-w>l')
-- vim.keymap.set({ 'n' }, '<A-h>', '<C-w>h')
-- vim.keymap.set({ 'n' }, '<A-j>', '<C-w>j')
-- vim.keymap.set({ 'n' }, '<A-k>', '<C-w>k')
-- vim.keymap.set({ 'n' }, '<A-l>', '<C-w>l')

-- AUTOCOMMANDS (EVENT HANDLERS)
--
-- See `:h lua-guide-autocommands`, `:h autocmd`, `:h nvim_create_autocmd()`

-- Highlight when yanking (copying) text.
-- Try it with `yap` in normal mode. See `:h vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  callback = function() vim.hl.on_yank() end,
})

-- USER COMMANDS: DEFINE CUSTOM COMMANDS
--
-- See `:h nvim_create_user_command()` and `:h user-commands`

-- Create a command `:GitBlameLine` that print the git blame for the current line
vim.api.nvim_create_user_command('GitBlameLine', function()
  local line_number = vim.fn.line '.' -- Get the current line number. See `:h line()`
  local filename = vim.api.nvim_buf_get_name(0)
  print(vim.system({ 'git', 'blame', '-L', line_number .. ',+1', filename }):wait().stdout)
end, { desc = 'Print the git blame for the current line' })
