return {
  -- Copilot
  {
    "github/copilot.vim",
    lazy = false,
    cond = os.getenv("DJN_COPILOT") ~= "0",
    config = function()
      vim.keymap.set(
        "i",
        "<C-J>",
        'copilot#Accept("")',
        { expr = true, replace_keycodes = false, desc = "Accept Copilot suggestion" }
      )
      vim.g.copilot_no_tab_map = true

      vim.keymap.set("i", "<C-K>", "<Plug>(copilot-accept-line)")
      vim.keymap.set("i", "<C-L>", "<Plug>(copilot-accept-word)")
    end,
  },

  -- Terminal shenanigans
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      vim.o.hidden = true
      require("toggleterm").setup({
        open_mapping = [[<Leader>tt]],
        insert_mappings = false,
      })
    end,
  },

  -- Better folding
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    lazy = false,
    config = function()
      vim.o.foldcolumn = "0" -- '0' is not bad
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
      vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
      vim.keymap.set("n", "zm", require("ufo").closeFoldsWith)
      -- Folding capabilities for LSP servers should be set already in mason-lspconfig b/c it has a higher priority
      require("ufo").setup()
    end,
  },

  -- Indentation lines to guide you
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      scope = {
        show_start = false,
        show_end = false,
      },
    },
  },

  -- Add git signs to the left of the line number
  -- "airblade/vim-gitgutter",
  {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    config = true,
  },

  -- Testing code
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
    },
    ft = { "python" },
    opts = function()
      return {
        adapters = {
          require("neotest-python"),
        },
      }
    end,
  },

  -- Easily comment code sections
  {
    "numToStr/Comment.nvim",
    opts = {
      -- add any options here
    },
    lazy = false,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      require("plugins.config.nvim-cmp.config")
    end,
  },

  -- Auto close brackets
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        enable_check_bracket_line = false,
      })
      -- If you want insert `(` after select function or method item
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- Git diff view
  {
    "sindrets/diffview.nvim"
  },
}
