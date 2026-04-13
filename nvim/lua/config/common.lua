local M = vim.empty_dict()

local lsp_mapping = {
  c = { 'clangd' },
  cpp = { 'clangd' },
  go = { 'gopls' },
  json = { 'jsonls' },
  lua = { 'lua_ls', 'stylua' },
  php = { 'intelephense' },
  python = { 'ty' },
  rust = { 'rust-analyzer' },
  yaml = { 'yamlls' }
}

--- Load Language Server List
--- @param languages table enabled_languages list
--- @return table LSP server list
M.language_servers = function(languages)
  local ret = {}
  if vim.islist(languages) and #languages then
    local tmp = {}
    for _, language in ipairs(languages) do
      vim.list_extend(tmp, lsp_mapping[language] or {})
    end

    ret = vim.iter(tmp):flatten():unique():totable()
  end
  return ret
end


return M
