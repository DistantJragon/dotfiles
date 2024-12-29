local packages_to_install = {
  -- DAPs
  ["bash-debug-adapter"] = {},
  -- NOTE: cpptools takes ~220 MB
  ["cpptools"] = {},
  ["java-debug-adapter"] = {},
  ["js-debug-adapter"] = {},
  -- No Python DAP listed here
  -- Python DAP is configured in nvim-dap-python
  -- I haven't figured out how to configure Python debugging with the executable installed by mason
  -- Nevermind, but keeping the above comments until I've tested it
  ["debugpy"] = { "python" },

  -- Linters (configure with nvim-lint)
  ["cpplint"] = { cmds = { "python" } },
  ["cmakelint"] = { cmds = { "python" } },
  ["cspell"] = { cmds = { "npm" } },
  ["htmlhint"] = { cmds = { "npm" } },
  ["checkstyle"] = {},
  ["biome"] = { cmds = { "npm" } },
  ["jsonlint"] = { cmds = { "npm" } },
  ["luacheck"] = { cmds = { "luarocks" } },
  ["markdownlint"] = { cmds = { "npm" } },
  ["shellcheck"] = {},
  ["flake8"] = { cmds = { "python" } },
  ["vint"] = { cmds = { "python" } },

  -- Formatters (configure with formatter.nvim)
  ["clang-format"] = { cmds = { "python" } },
  ["prettierd"] = { cmds = { "npm" } },
  ["latexindent"] = {},
  ["stylua"] = {},
  ["autoflake"] = { cmds = { "python" } },
  ["isort"] = { cmds = { "python" } },
  ["ruff"] = { cmds = { "python", "cargo", "rustc" } },
  ["autopep8"] = { cmds = { "python" } },
  ["shfmt"] = {},
  ["beautysh"] = { cmds = { "python" } },

  -- LSPs are configured in mason-lspconfig
}

-- When mason tries to install checkmake on Windows, it says "The current platform is unsupported."
-- Could change in the future, but for now, I guess it's not supported on Windows
if vim.fn.has("win32") == 0 then
  packages_to_install["checkmake"] = {}
end

return packages_to_install
