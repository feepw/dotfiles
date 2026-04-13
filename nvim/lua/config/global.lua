-- Global Variable Intialization
local M = vim.empty_dict()

local enabled_languages = function()
  -- Parse enabled langauges from system environment
  vim.g.enabled_languages = vim.iter(
    vim.split(vim.env.NVIM_ENABLED_LANGUAGES or 'lua', ',')
  ):map(vim.fn.tolower):
  totable()
end

M.init = function() enabled_languages() end

return M
