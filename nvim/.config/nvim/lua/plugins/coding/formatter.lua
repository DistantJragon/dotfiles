-- Formatter
local formatters_by_ft = function()
  local formatters = {
    c = { require("formatter.filetypes.c").clangformat },
    html = { require("formatter.filetypes.html").prettierd },
    java = { require("formatter.filetypes.java").clangformat },
    javascript = {
      require("formatter.filetypes.javascript").clangformat,
      require("formatter.filetypes.javascript").prettierd,
    },
    json = { require("formatter.filetypes.json").prettierd },
    latex = { require("formatter.filetypes.latex").latexindent },
    lua = {
      function()
        local util = require("formatter.util")
        local args
        if vim.fn.filereadable(".stylua.toml") == 1 or vim.fn.filereadable("stylua.toml") == 1 then
          args = {
            "--search-parent-directories",
            "--stdin-filepath",
            util.escape_path(util.get_current_buffer_file_path()),
            "--",
            "-",
          }
        else
          args = {
            "--config-path",
            vim.fn.stdpath("config") .. "/lua/plugins/config/formatter/stylua.toml",
            "--search-parent-directories",
            "--stdin-filepath",
            util.escape_path(util.get_current_buffer_file_path()),
            "--",
            "-",
          }
        end
        return {
          exe = "stylua",
          args = args,
          stdin = true,
        }
      end,
    },
    markdown = { require("formatter.filetypes.markdown").prettierd },
    python = {
      require("formatter.filetypes.python").autoflake,
      require("formatter.filetypes.python").isort,
      require("formatter.filetypes.python").ruff,
      require("formatter.filetypes.python").autopep8,
    },
    sh = { require("formatter.filetypes.sh").shfmt },
    zsh = { require("formatter.filetypes.zsh").beautysh },
    ["*"] = {},
  }

  -- Add a formatter to remove trailing whitespace for all filetypes except Windows
  -- (It uses sed which is not available on Windows)
  if vim.fn.has("win32") == 0 then
    table.insert(formatters["*"], require("formatter.filetypes.any").remove_trailing_whitespace)
  end
  return formatters
end

return {
  "mhartington/formatter.nvim",
  init = function()
    vim.api.nvim_create_augroup("__formatter__", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePost", {
      group = "__formatter__",
      command = ":FormatWrite",
    })
  end,
  cmd = { "FormatWrite" },
  config = function()
    require("formatter").setup({
      filetype = formatters_by_ft(),
    })
  end,
}
