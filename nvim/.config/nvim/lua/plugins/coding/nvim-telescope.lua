-- Fuzzy finder
local build_command = ""
local telescope_deps = {
  "nvim-lua/plenary.nvim",
}
if vim.fn.executable("cmake") == 1 and vim.fn.executable("nmake") == 1 then
  build_command = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release"
elseif vim.fn.executable("make") == 1 then
  build_command = "make"
end
if build_command ~= "" then
  table.insert(telescope_deps, { "nvim-telescope/telescope-fzf-native.nvim", build = build_command })
end
return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  -- tag = '0.1.6', or branch = '0.1.x',
  dependencies = telescope_deps,
  config = function()
    local telescope = require("telescope")
    -- You dont need to set any of these options. These are the default ones. Only the loading is important
    telescope.setup({
      extensions = {
        fzf = {
          fuzzy = true, -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true, -- override the file sorter
          case_mode = "smart_case", -- or "ignore_case" or "respect_case"
          -- the default case_mode is "smart_case"
        },
      },
      defaults = {
        file_ignore_patterns = {
          "node_modules",
          ".git",
          ".cache",
          ".vscode",
          ".idea",
        },
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
        },
      },
    })
    -- To get fzf loaded and working with telescope, you need to call
    -- load_extension, somewhere after setup function:
    if build_command ~= "" then
      require("telescope").load_extension("fzf")
    end

    vim.api.nvim_create_autocmd({ "LspAttach" }, {
      callback = function()
        -- which-key spec v2
        -- require("which-key").register({
        --     g = {
        --       name = "Goto",
        --       d = { vim.lsp.buf.definition, "Go to definition" },
        --       r = {
        --         require("telescope.builtin").lsp_references,
        --         "Open a telescope window with references",
        --       },
        --     },
        --   }, { buffer = 0 })
        -- end,
        -- which-key spec v3
        require("which-key").add({
          { "g", buffer = 0, group = "Goto" },
          { "gd", vim.lsp.buf.definition, buffer = 0, desc = "Go to definition" },
          {
            "grt",
            require("telescope.builtin").lsp_references,
            buffer = 0,
            desc = "Open a telescope window with references",
          },
        })
      end,
    })
  end,
}
