return {
  -- Programming plugin manager
  {
    "williamboman/mason.nvim",
    lazy = false,
    priority = 52, -- Must be loaded before mason-lspconfig, lspconfig, and mason-nvim-dap
    config = function()
      local package_list = (require("plugins.config.mason.package-buildable-filter"))(
        require("plugins.config.mason.packages")
      )
      require("mason").setup({
        -- log_level = vim.log.levels.DEBUG,
      })
      vim.api.nvim_create_user_command("MasonInstallAll", function()
        require("plugins.config.mason.install-all-cmd")(package_list)
      end, {})
      -- Comment out the following line if you don't want to install all packages on startup
      require("plugins.config.mason.install-all-cmd")(package_list)
    end,
  },

  -- Connects mason and nvim-lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    priority = 51, -- Must be loaded before lspconfig
    opts = {
      ensure_installed = (require("plugins.config.mason.package-buildable-filter"))(
        require("plugins.config.mason-lspconfig.lsps")
      ),
    },
    config = function(_, opts)
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }
      require("mason-lspconfig").setup(opts)
      -- Automatic LSP server setup in mason-lspconfig is "advanced."
      -- TODO: It is recommended by mason-lspconfig to manually configure LSP servers (in nvim-lspconfig).
      -- (I don't care enough to do it myself yet)
      -- Just make sure to comment out the following block if you do (see :h lspconfig-quickstart)
      require("mason-lspconfig").setup_handlers({
        -- First entry is the default handler
        function(server_name)
          require("lspconfig")[server_name].setup({ capabilities = capabilities })
        end,
        -- Custom handlers after (e.g ["pyright"] = function() ... end,)
        ["ltex"] = function()
          require("lspconfig").ltex.setup({
            capabilities = capabilities,
            settings = {
              ltex = {
                language = "en-US",
                disabledRules = {
                  ["en-US"] = { "MORFOLOGIK_RULE_EN_US" },
                },
              },
            },
          })
        end,
        ["lua_ls"] = function()
          require("lspconfig").lua_ls.setup({
            capabilities = capabilities,
            on_init = function(client)
              if client.workspace_folders then
                local path = client.workspace_folders[1].name
                if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
                  return
                end
              end

              client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
                runtime = {
                  -- Tell the language server which version of Lua you're using
                  -- (most likely LuaJIT in the case of Neovim)
                  version = "LuaJIT",
                },
                -- Make the server aware of Neovim runtime files
                workspace = {
                  checkThirdParty = false,
                  library = {
                    vim.env.VIMRUNTIME,
                    -- Depending on the usage, you might want to add additional paths here.
                    -- "${3rd}/luv/library"
                    -- "${3rd}/busted/library",
                  },
                  -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on
                  -- your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
                  -- library = vim.api.nvim_get_runtime_file("", true)
                },
              })
            end,
            settings = {
              Lua = {},
            },
          })
        end,
      })
    end,
  },

  -- LSP configuration
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    -- LSPs should be configured from within mason-lspconfig (configs can be customized there too)
  },

  -- Connects NeoVim to DAP(s)
  {
    "mfussenegger/nvim-dap",
    config = function()
      -- python is configured within nvim-dap-python. Languages with no extensions can be added here.
      -- Configure adapters and configurations for the languages
      local dap = require("dap")
      dap.adapters.cppdbg = {
        id = "cppdbg",
        type = "executable",
        -- command = "OpenDebugAD7", -- mason should have added this to the path, so it should work (it doesnt?)
        command = vim.fn.exepath("OpenDebugAD7"),
      }
      if vim.fn.has("win32") == 1 then
        dap.adapters.cppdbg.options = { detached = false }
      end
      dap.configurations.cpp = {
        {
          name = "Launch file",
          type = "cppdbg",
          request = "launch",
          program = function()
            if vim.fn.executable(vim.fn.getcwd() .. "/a.out") == 1 then
              return vim.fn.getcwd() .. "/a.out"
            end
            if vim.fn.executable(vim.fn.getcwd() .. "/a.exe") == 1 then
              return vim.fn.getcwd() .. "/a.exe"
            end
            local path = vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            if vim.fn.executable(path) == 1 then
              return path
            end
            return nil
          end,
          cwd = "${workspaceFolder}",
          stopAtEntry = true,
          setupCommands = {
            {
              text = "-enable-pretty-printing",
              description = "enable pretty printing",
              ignoreFailures = false,
            },
          },
        },
        --[[
        {
          name = 'Attach to gdbserver :1234',
          type = 'cppdbg',
          request = 'launch',
          MIMode = 'gdb',
          miDebuggerServerAddress = 'localhost:1234',
          miDebuggerPath = '/usr/bin/gdb',
          cwd = '${workspaceFolder}',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          setupCommands = {
            {
              text = '-enable-pretty-printing',
              description = 'enable pretty printing',
              ignoreFailures = true
            },
          },
        },
        --]]
      }
      dap.configurations.c = dap.configurations.cpp
      dap.configurations.rust = dap.configurations.cpp
    end,
  },

  -- Adds TUI to nvim-dap
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    lazy = false,
    config = true,
  },

  -- Prints virtual texts to warn/inform user while coding
  "theHamsta/nvim-dap-virtual-text",

  -- Python DAP support plugin
  {
    "mfussenegger/nvim-dap-python",
    ft = { "python" },
    config = function()
      local debugpy_location = require("plugins.config.nvim-dap-python.debugpy-location")
      if debugpy_location then
        require("dap-python").setup(debugpy_location)
      end
    end,
  },
}
