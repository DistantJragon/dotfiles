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
})
