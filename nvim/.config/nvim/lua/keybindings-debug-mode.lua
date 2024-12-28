vim.g.DJNCFG_debug_mode_mappings = false

local function ensure_tab_var_defined()
  vim.t.djn_debug_mode = vim.t.djn_debug_mode or false
end

-- NOTE: This functionality can be rewritten if/when namespace support is added to keybindings
-- (or some other way to configure custom keybindings without overwriting the default ones)

local original_keymaps = {
  n = vim.api.nvim_get_keymap("n"),
  i = vim.api.nvim_get_keymap("i"),
  v = vim.api.nvim_get_keymap("v"),
}

local debug_keymappings = {
  b = { bind = ':lua require("dap").toggle_breakpoint()<CR>', desc = "Toggle breakpoint" },
  B = {
    bind = ':lua require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>',
    desc = "Set breakpoint condition",
  },
  m = {
    bind = ':lua require("dap").set_breakpoint({ nil, nil, vim.fn.input("Log point message: ") })<CR>',
    desc = "Set log point",
  },
  c = { bind = ':lua require("dap").continue()<CR>', desc = "Continue (Debug)" },
  n = { bind = ':lua require("dap").step_over()<CR>', desc = "Step over [next] (Debug)" },
  si = { bind = ':lua require("dap").step_into()<CR>', desc = "Step into (Debug)" },
  so = { bind = ':lua require("dap").step_out()<CR>', desc = "Step out (Debug)" },
  vh = { bind = ':lua require("dap.ui.variables").hover()<CR>', desc = "Hover Variables" },
  vvh = { bind = ':lua require("dap.ui.variables").visual_hover()<CR>', desc = "Visual Hover Variables" },
  vs = { bind = ':lua require("dap.ui.variables").scopes()<CR>', desc = "Scopes" },
  w = {
    bind = ':lua require("dap.ui.widgets").centered_float(require("dap.ui.widgets").scopes)<CR>',
    desc = "Scopes",
  },
  ro = { bind = ':lua require("dap").repl.open()<CR>', desc = "Open REPL" },
}

local function debug_mode_activate()
  if vim.g.DJNCFG_debug_mode_mappings then
    vim.notify(
      "Debug mode mappings already active. This shouldn't happen...",
      vim.log.levels.WARN,
      { title = "Debug Mode" }
    )
    return
  end
  vim.g.DJNCFG_debug_mode_mappings = true
  for key, value in pairs(debug_keymappings) do
    vim.keymap.set("n", key, value.bind, { silent = true, desc = value.desc })
  end
end

local function debug_mode_deactivate()
  if not vim.g.DJNCFG_debug_mode_mappings then
    vim.notify(
      "Debug mode mappings already deactivated. This shouldn't happen...",
      vim.log.levels.WARN,
      { title = "Debug Mode" }
    )
    return
  end
  vim.g.DJNCFG_debug_mode_mappings = false
  for key, value in pairs(debug_keymappings) do
    if original_keymaps.n[key] then
      vim.keymap.set("n", key, original_keymaps.n[key].rhs, original_keymaps.n[key])
    else
      vim.keymap.del("n", key)
    end
  end
end

local function check_debug_mode()
  ensure_tab_var_defined()
  if vim.g.DJNCFG_debug_mode_mappings ~= vim.t.djn_debug_mode then
    if vim.g.DJNCFG_debug_mode_mappings then
      debug_mode_deactivate()
    else
      debug_mode_activate()
    end
  end
end

vim.keymap.set("n", "<Leader>db", function()
  ensure_tab_var_defined()
  -- Toggle the debug mode
  vim.t.djn_debug_mode = not vim.t.djn_debug_mode
  if vim.t.djn_debug_mode then
    require("dapui").open()
    debug_mode_activate()
  else
    require("dapui").close()
    debug_mode_deactivate()
  end
end, { desc = "Toggle Debug Mode" })

vim.keymap.set("n", "<Leader>ddb", function()
  ensure_tab_var_defined()
  vim.t.djn_debug_mode = not vim.t.djn_debug_mode
end, { desc = "Toggle Debug Mode global variable" })

-- When the user changes tab, if that tab isn't also in debug mode, deactivate the debug mode mappings using an autocmd
vim.api.nvim_create_augroup("DJNCFG_debug_mode", { clear = false })
vim.api.nvim_create_autocmd("TabEnter", {
  group = "DJNCFG_debug_mode",
  pattern = "*",
  callback = check_debug_mode,
})
