return {
  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    init = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      vim.opt.termguicolors = true
    end,
    config = function()
      require("nvim-tree").setup({
        filters = {
          custom = {
            "^\\.git", -- hide .git folder
          },
        },
        renderer = {
          add_trailing = true,
          group_empty = true,
          full_name = true,
          hidden_display = "all",
        },
      })
      vim.keymap.set("n", "<Leader>e", function()
        require("nvim-tree.api").tree.open()
      end, { desc = "Open/Focus NvimTree" })
    end,
  },

  -- Status line at the bottom of the screen
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    opts = {
      open_on_setup = true,
      open_on_setup_file = true,
      sections = {
        lualine_a = {
          "mode",
          function()
            return vim.g.DJNCFG_debug_mode_mappings and "DEBUG" or ""
          end,
        },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = {
          "filename",
          function()
            local linters = require("lint").get_running()
            if #linters == 0 then
              return "󰦕"
            end
            return "󱉶 " .. table.concat(linters, ", ")
          end,
        },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- Color theme
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("duskfox")
    end,
  },

  -- Shows a popup with possible keybindings after starting a keybind sequence
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },

  -- Render markdown files within Neovim
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {},
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
  },
}
