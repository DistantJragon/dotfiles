local debugpy_location = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv"
local ignore_debugpy_error = false
if vim.fn.has("win32") == 1 then
  debugpy_location = debugpy_location .. "/Scripts/python.exe"
else
  debugpy_location = debugpy_location .. "/bin/python"
end
-- debugpy_location = "Uncomment this line and write the path to the debugpy executable here if you don't want to"
--   .. "use the debugpy mason package"
if vim.fn.executable(debugpy_location) == 0 then
  if not ignore_debugpy_error then
    vim.notify(
      "Debugpy not found at "
        .. debugpy_location
        .. "\nThis means the debugpy package is not installed in the mason package manager"
        .. "\n(Or you have set debugpy_location to an incorrect path)"
        .. "\nYou won't be able to debug python code in neovim until this is resolved."
        .. "\nYou can suppress this message by setting ignore_debugpy_error = true in "
        .. vim.fn.stdpath("config")
        .. "lua/plugins/config/debugpy-location.lua"
        .. "\n",
      vim.log.levels.WARN
    )
  end
  debugpy_location = ""
end

return debugpy_location
