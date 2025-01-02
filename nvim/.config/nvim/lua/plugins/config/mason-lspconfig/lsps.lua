local python_command = vim.fn.has("win32") == 1 and "python" or "python3"

return {
  -- Assembly
  ["asm_lsp"] = { cmds = { "cargo" } },

  -- Python
  -- NOTE: basedpyright takes ~160 MB
  ["basedpyright"] = { cmds = { python_command } },

  -- Bash
  ["bashls"] = { cmds = { "npm" } },

  -- JavaScript
  ["biome"] = { cmds = { "npm" } },

  -- C/C++
  ["clangd"] = {},

  -- CMake
  ["cmake"] = { cmds = { python_command } },

  -- CSS
  ["css_variables"] = { cmds = { "npm" } },
  ["cssls"] = { cmds = { "npm" } },
  ["cssmodules_ls"] = { cmds = { "npm" } },

  -- Docker
  ["docker_compose_language_service"] = { cmds = { "npm" } },
  ["dockerls"] = { cmds = { "npm" } },

  -- HTML
  ["html"] = { cmds = { "npm" } },

  -- HTMX
  ["htmx"] = { cmds = { "cargo" } },

  -- Java
  ["java_language_server"] = { cmds = { "jlink", "mvn", "bash" } },
  ["jdtls"] = {},

  -- JSON
  ["jsonls"] = { cmds = { "npm" } },

  -- LaTeX
  -- NOTE: LaTeX Language Server takes ~300 MB
  -- ["ltex"] = {},

  -- Lua
  ["lua_ls"] = {},

  -- Markdown
  ["marksman"] = {},

  -- PowerShell
  -- NOTE: Powershell Editor Services takes ~300 MB
  -- ["powershell_es"] = { "pwsh" },

  -- Rust
  ["rust_analyzer"] = {},

  -- Spell checking
  ["typos_lsp"] = {},

  -- Vim
  ["vimls"] = { cmds = { "npm" } },
}
