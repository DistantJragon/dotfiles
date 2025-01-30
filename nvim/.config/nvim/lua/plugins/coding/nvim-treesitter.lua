local M = {}
local treesitter_plugin_spec = {
  "nvim-treesitter/nvim-treesitter",
  build = function()
    require("nvim-treesitter.install").update({ with_sync = true })()
  end,
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = require("plugins.config.nvim-treesitter.parsers"),
      sync_install = false,
      highlight = {
        enable = true,
        disable = function(lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          if lang == "latex" then
            return
          end
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
      },
      indent = { enable = true },
    })
    require("nvim-treesitter.install").prefer_git = false -- use curl+tar instead
    -- may need to comment out above or download tar if on Windows and nvim-treesitter can't download parsers
    -- curl+tar will be default in future versions of nvim-treesitter
  end,
}
if require("plugins.config.has-c-compiler") then
  -- Facilitates using treesitter's interface (TS is for syntax highlighting)
  table.insert(M, treesitter_plugin_spec)
else
  vim.notify(
    "nvim-treesitter was not installed because no C compiler found"
      .. "\nIf you are on Windows, you can visit this wiki page on the plugin's GitHub for help:"
      .. "\nhttps://github.com/nvim-treesitter/nvim-treesitter/wiki/Windows-support",
    vim.log.levels.WARN
  )
end

return M
