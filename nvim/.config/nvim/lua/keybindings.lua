local which_key = require("which-key")
-- Run keybindings-debug-mode.lua
require("keybindings-debug-mode")

-- Exit terminal mode with escape
-- vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { silent = true })
which_key.add({
  { "<Esc>", "<C-\\><C-n>", mode = "t", desc = "Exit terminal mode with escape" },
})

-- Remove search highlighting with escape
-- vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { silent = true })
which_key.add({
  {
    "<Esc>",
    function()
      vim.cmd("nohlsearch")
    end,
    mode = "n",
    desc = "Remove search highlighting with escape",
  },
  { "<Leader>t", group = "toggleterm" },
  { "<Leader>tb", "<cmd>ToggleTerm direction=tab<CR>", desc = "Toggle terminal tab" },

  { "<Leader>f", group = "find" },
  { "<Leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
  { "<Leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
  { "<Leader>fb", "<cmd>Telescope buffers<CR>", desc = "Find buffers" },
  { "<Leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
  { "<Leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
  { "<Leader>fl", "<cmd>Telescope resume<CR>", desc = "Resume last search" },

  { "<Leader>n", group = "new" },
  { "<Leader>nt", "<cmd>tabnew<CR>", desc = "New tab" },
  { "<Leader>nvb", "<cmd>vsplit<CR>", desc = "New vertical buffer" },
  { "<Leader>nhb", "<cmd>split<CR>", desc = "New horizontal buffer" },
})
