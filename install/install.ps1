$packages = @()
. $PSScriptRoot\nvim.ps1
. $PSScriptRoot\powershell-profile.ps1

while ($true) {
  Write-Host "Available packages:"
  for ($i = 0; $i -lt $packages.Length; $i++) {
    Write-Host "$($i + 1): $($packages[$i].Name)"
  }
  # Prompt the user to select a package
  $user_input = Read-Host "Select a package to install (q to quit)"
  if ($user_input -eq "q") {
    break
  }
  $user_input = [int]$user_input
  if ($user_input -ge 0 -and $user_input -lt $packages.Length) {
    $package = $packages[$user_input - 1]
    $install_result = & $package.Install
    if ($install_result -eq 0) {
      Write-Host "$($package.Name) installed successfully"
    } else {
      Write-Host "Failed to install $($package.Name)"
    }
  } else {
    Write-Host "Invalid input"
  }
}
