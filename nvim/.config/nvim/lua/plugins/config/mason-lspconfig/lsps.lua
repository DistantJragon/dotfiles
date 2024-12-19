return {
  -- Assembly
  ["asm_lsp"] = { cmds = { "cargo" } },
  -- Python
  -- NOTE: basedpyright takes ~160 MB
  -- It may (probably) need cargo/rustc to build. TODO: More testing is needed.
  ["basedpyright"] = { cmds = { "python" } },
  -- Bash
  ["bashls"] = { cmds = { "npm" } },
  -- JavaScript
  ["biome"] = { cmds = { "npm" } },
  -- C/C++
  ["clangd"] = {},
  -- CMake
  ["cmake"] = { cmds = { "python" } },
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
  -- ["java_language_server"] = { cmds = { "jlink", "mvn", "bash" } },
  ["jdtls"] = {},
  -- JSON
  ["jsonls"] = { cmds = { "npm" } },
  -- LaTeX
  -- NOTE: LaTeX Language Server takes ~300 MB
  ["ltex"] = {},
  -- Lua
  ["lua_ls"] = {},
  -- Markdown
  ["marksman"] = {},
  -- PowerShell
  -- NOTE: Powershell Editor Services takes ~300 MB
  ["powershell_es"] = {},
  -- Rust
  ["rust_analyzer"] = {},
  -- Spell checking
  ["typos_lsp"] = {},
  -- Vim
  ["vimls"] = { cmds = { "npm" } },
}
