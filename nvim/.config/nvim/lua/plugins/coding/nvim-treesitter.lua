local M = {}

local treesitter_plugin_spec = {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    require("nvim-treesitter").install(require("plugins.config.nvim-treesitter.parsers"))
  end,
}
-- may need download tar if on Windows and nvim-treesitter can't download parsers
-- curl+tar will be default in future versions of nvim-treesitter

if require("plugins.config.has-c-compiler") then
  -- Facilitates using treesitter's interface (TS is for syntax highlighting)
  table.insert(M, treesitter_plugin_spec)
else
  vim.notify(
    "nvim-treesitter was not installed because no C compiler found",
    vim.log.levels.WARN
  )
end

return M
