-- In vimscript from :h shell-powershell
-- let &shell = executable('pwsh') ? 'pwsh' : 'powershell'
-- let &shellcmdflag = '-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues[''Out-File:Encoding'']=''utf8'';Remove-Alias -Force -ErrorAction SilentlyContinue tee;'
-- let &shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
-- let &shellpipe  = '2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode'
-- set shellquote= shellxquote=

local force_pwsh = false -- Set to true to force using pwsh (Works for both Windows and Unix)
if vim.fn.has("win32") == 1 or (vim.executable("pwsh") == 1 and force_pwsh) then
  local powershell_cmd = force_pwsh and "pwsh" or "powershell"
  local remove_tee_alias = force_pwsh and "Remove-Alias -Force -ErrorAction SilentlyContinue tee;"
    or "Remove-Item Alias:tee -Force -ErrorAction SilentlyContinue;"
  -- Convert the above vimscript to lua
  vim.opt.shell = powershell_cmd
  vim.opt.shellcmdflag = "-NoLogo -ExecutionPolicy RemoteSigned"
    .. " -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();"
    .. "$PSDefaultParameterValues['Out-File:Encoding']='utf8';"
    .. remove_tee_alias
  vim.opt.shellredir = '2>&1 | %{ "$_" } | Out-File %s; exit $LastExitCode'
  vim.opt.shellpipe = '2>&1 | %{ "$_" } | tee %s; exit $LastExitCode'
  vim.opt.shellquote = ""
  vim.opt.shellxquote = ""
end
