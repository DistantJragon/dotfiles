#Requires -RunAsAdministrator

# TODO: Make this script work with install.ps1
if ($djncfg_interactive) {
  # Exit this script
  return
}
Write-Host "Installing Windows Terminal settings"

$wTSettingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$configPath = "$PSScriptRoot\..\windows-terminal\settings.json" | Resolve-Path

if ((Test-Path $wTSettingsPath) -and (Test-Path $configPath)) {
  Copy-Item -Path $wTSettingsPath -Destination "$HOME\wTSettings.json.bak" -Force
  New-Item -ItemType SymbolicLink -Path $wTSettingsPath -Value $configPath -Force
}
