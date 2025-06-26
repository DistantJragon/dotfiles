return {
  -- Programming plugin manager
  {
    "mason-org/mason.nvim",
    lazy = false,
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
    "mason-org/mason-lspconfig.nvim",
    -- lazy = false,
    dependencies = {
      "mason-org/mason.nvim", -- Not a dependency, but should be loaded
      "neovim/nvim-lspconfig", -- Not a dependency, but should be loaded
    },
    opts = {
      ensure_installed = (require("plugins.config.mason.package-buildable-filter"))(
        require("plugins.config.mason-lspconfig.lsps")
      ),
    },
  },

  -- LSP configuration
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "mason-org/mason.nvim", -- Not a dependency, but should be loaded
    },
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
