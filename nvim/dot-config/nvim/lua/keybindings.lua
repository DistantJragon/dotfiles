local which_key = require("which-key")
-- Run keybindings-debug-mode.lua
require("keybindings-debug-mode")

which_key.add({
  -- Remove search highlighting with escape
  {
    "<Esc>",
    function()
      vim.cmd("nohlsearch")
    end,
    mode = "n",
    desc = "Remove search highlighting with escape",
  },

  -- Toggleterm keybindings
  { "<Leader>t", group = "toggleterm" },
  { "<Leader>tb", "<cmd>ToggleTerm direction=tab<CR>", desc = "Toggle terminal tab" },

  -- Telescope keybindings
  { "<Leader>f", group = "find" },
  { "<Leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
  { "<Leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
  { "<Leader>fb", "<cmd>Telescope buffers<CR>", desc = "Find buffers" },
  { "<Leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
  { "<Leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
  { "<Leader>fl", "<cmd>Telescope resume<CR>", desc = "Resume last search" },

  -- New file/buffer keybindings
  { "<Leader>n", group = "new" },
  { "<Leader>nt", "<cmd>tabnew<CR>", desc = "New tab" },
  { "<Leader>nvb", "<cmd>vsplit<CR>", desc = "New vertical buffer" },
  { "<Leader>nhb", "<cmd>split<CR>", desc = "New horizontal buffer" },

  -- Exit terminal mode with escape
  { "<Esc>", "<C-\\><C-n>", mode = "t", desc = "Exit terminal mode with escape" },

  -- System clipboard keybindings
  { "<Leader>y", '"+y', mode = { "n", "v" }, desc = "Yank to system clipboard" },
  { "<Leader>Y", '"+Y', mode = "n", desc = "Yank line to system clipboard" },

  { "<Leader>p", '"+p', mode = { "n", "v" }, desc = "Paste from system clipboard" },
  { "<Leader>P", '"+P', mode = "n", desc = "Paste before from system clipboard" },
})
