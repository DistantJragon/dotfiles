#Requires -RunAsAdministrator

$packages = @()
$djncfg_interactive = $true

# Run all files in the packages with .
$package_files = Get-ChildItem -Path "$PSScriptRoot\packages" -Filter "*.ps1"
foreach ($file in $package_files) {
  . $file.FullName
}

$user_input = ""
while ($user_input -ne "q") {
  Write-Host "Available packages:"
  for ($i = 0; $i -lt $packages.Length; $i++) {
    Write-Host "$($i + 1): $($packages[$i].Name)"
  }
  # Prompt the user to select a package
  $user_input = Read-Host "Select a package to install (q to quit)"
  if ($user_input -eq "q") {
    break
  }
  if (-not $user_input -match "^\d+$") {
    Write-Host "Invalid input"
    continue
  }
  $choice = [int]$user_input - 1
  if ($choice -lt 0 -or $choice -ge $packages.Length) {
    Write-Host "Invalid input"
    continue
  }
  $package = $packages[$choice]
  $install_result = & $package.Install
  if ($install_result -eq 0) {
    Write-Host "$($package.Name) installed successfully"
  } else {
    Write-Host "Failed to install $($package.Name)"
  }
}

# Delete leftover variables
Remove-Variable -Name packages
Remove-Variable -Name djncfg_interactive
