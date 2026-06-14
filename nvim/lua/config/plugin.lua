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
local lss = require 'config.common'.language_servers(vim.g.enabled_languages)
require('mason-lspconfig').setup {
  ensure_installed = lss
}

if vim.list_contains(lss, 'vue_ls') then
  -- If you are using mason.nvim, you can get the ts_plugin_path like this
  -- For Mason v1,
  local mason_registry = require('mason-registry')
  -- local vue_language_server_path = mason_registry.get_package('vue-language-server'):get_install_path() .. '/node_modules/@vue/language-server'
  -- For Mason v2,
  local vue_language_server_path = vim.fn.expand '$MASON/packages' ..
  '/vue-language-server' .. '/node_modules/@vue/language-server'
  -- or even
  -- local vue_language_server_path = vim.fn.stdpath('data') .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

  local vue_plugin = {
    name = '@vue/typescript-plugin',
    location = vue_language_server_path,
    languages = { 'vue' },
    configNamespace = 'typescript',
  }
  vim.lsp.config.ts_ls = {
    init_options = {
      plugins = {
        vue_plugin,
      },
    },
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' }
  }
end

require('nvim-surround').setup {}
require('quicker').setup {}
require('render-markdown').setup {}
