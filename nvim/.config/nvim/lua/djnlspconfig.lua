-- Need to update LSP capabilities to support folding ranges for nvim-ufo
local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}
vim.lsp.config("*", {
  capabilities = capabilities,
})

vim.lsp.config("ltex", {
  settings = {
    ltex = {
      language = "en-US",
      disabledRules = {
        ["en-US"] = { "MORFOLOGIK_RULE_EN_US" },
      },
    },
  },
})

vim.lsp.config("lua_ls", {
  on_init = function(client)
    local path = ""
    if client.workspace_folders then
      path = client.workspace_folders[1].name
    else
      return
    end
    -- Manipulate the config path to resolve symlinks and replace backslashes on Windows
    local neovim_config_path = vim.fn.resolve(vim.fn.stdpath("config"))
    if vim.fn.has("win32") == 1 then
      neovim_config_path = neovim_config_path:gsub("\\", "/")
    end
    if neovim_config_path:find(path, 1, true) then
      print("config ran")
      client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
        runtime = {
          -- Tell the language server which version of Lua you're using (most
          -- likely LuaJIT in the case of Neovim)
          version = "LuaJIT",
          -- Tell the language server how to find Lua modules same way as Neovim
          -- (see `:h lua-module-load`)
          path = {
            "lua/?.lua",
            "lua/?/init.lua",
          },
        },
        -- Make the server aware of Neovim runtime files
        workspace = {
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME,
            -- Depending on the usage, you might want to add additional paths
            -- here.
            -- '${3rd}/luv/library'
            -- '${3rd}/busted/library'
          },
          -- Or pull in all of 'runtimepath'.
          -- NOTE: this is a lot slower and will cause issues when working on
          -- your own configuration.
          -- See https://github.com/neovim/nvim-lspconfig/issues/3189
          -- library = {
          --   vim.api.nvim_get_runtime_file('', true),
          -- }
        },
      })
    end
  end,
  settings = {
    Lua = {},
  },
})
