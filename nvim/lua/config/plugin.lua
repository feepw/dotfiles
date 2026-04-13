-- PLUGINS
--
-- See `:h :packadd`, `:h vim.pack`

-- Add the "nohlsearch" package to automatically disable search highlighting after
-- 'updatetime' and when going to insert mode.
vim.cmd('packadd! nohlsearch')
vim.cmd('packadd nvim.undotree')
vim.cmd('packadd nvim.difftool')

-- Install third-party plugins via "vim.pack.add()".
vim.pack.add({
  -- basic dependencies
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/nvim-lua/plenary.nvim',
  -- Colorscheme
  'https://github.com/f4z3r/gruvbox-material.nvim',
  -- Treesitter
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter',
    version = 'main'
  },
  -- Surround
  'https://github.com/kylechui/nvim-surround',
  -- LSP
  'https://github.com/neovim/nvim-lspconfig',
  -- Languages
  'https://github.com/folke/lazydev.nvim',
  'https://github.com/MeanderingProgrammer/render-markdown.nvim',
  -- Tool Manager
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  -- Fuzzy picker
  'https://github.com/ibhagwan/fzf-lua',
  -- Enhanced quickfix/loclist
  'https://github.com/stevearc/quicker.nvim',
  -- Git integration
  'https://github.com/lewis6991/gitsigns.nvim'
})

-- TreeSitter
local treesitter = require('nvim-treesitter')
treesitter.setup {
  -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
  install_dir = vim.fn.stdpath('data') .. '/site'
}
treesitter.install(vim.g.enabled_languages)
vim.api.nvim_create_autocmd('FileType', {
  pattern = vim.g.enabled_languages,
  callback = function(ev)
    if pcall(vim.treesitter.start, ev.buf) then
      vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.wo[0][0].foldmethod = 'expr'
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
  group = vim.api.nvim_create_augroup('TreeSitter', { clear = false }),
})

require('fzf-lua').setup { fzf_colors = true }
require('gitsigns').setup {}
require('gruvbox-material').setup {}
require('lazydev').setup {}
require('mason').setup {}
require('mason-lspconfig').setup {
  ensure_installed = require 'config.common'.language_servers(vim.g.enabled_languages)
}
require('nvim-surround').setup {}
require('quicker').setup {}
require('render-markdown').setup {}
