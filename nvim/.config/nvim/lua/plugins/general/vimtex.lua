local M = {
  -- Working with LaTeX
  {
    "lervag/vimtex",
    lazy = false,
    init = function()
      vim.g.vimtex_view_method = "sioyek"
      if require("plugins.config.has-c-compiler") then
        vim.g.matchup_override_vimtex = 1
      end
    end,
  },

  -- Manipulate surrounding enclosions like (), [], <p> (vimTeX requested)
  "tpope/vim-surround",
}

if require("plugins.config.has-c-compiler") then
  -- Extends Vim's surrounding enclosions for language specific surroundings (vimTeX requested)
  table.insert(M, "andymass/vim-matchup")
end

if vim.fn.executable("ctags") == 1 then
  -- Generate tags for the current project (Allows for jumping to definitions)
  table.insert(M, {
    "ludovicchabant/vim-gutentags",
    config = function()
      vim.g.gutentags_generate_on_write = 0
      vim.g.gutentags_generate_on_new = 0
      vim.g.gutentags_generate_on_missing = 0
      vim.g.gutentags_generate_on_empty_buffer = 0

      -- Use autocmds and :GutentagsUpdate to generate tags instead
      -- This way tags are only generated for LaTeX files
      local gutentags_group = vim.api.nvim_create_augroup("gutentags-latex", { clear = true })
      vim.api.nvim_create_autocmd(
        -- Generate tags when a new LaTeX file is created, opened, or saved
        { "BufNewFile", "BufRead", "BufWritePost" },
        {
          pattern = "*.tex",
          group = gutentags_group,
          command = "GutentagsUpdate",
        }
      )
    end,
  })
end

return M
