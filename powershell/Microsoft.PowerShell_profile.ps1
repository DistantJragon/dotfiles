# Set OHMYPOSH to the path of the oh-my-posh config file manually if automatic resolution is wished to be bypassed.
$OHMYPOSH = ""

$PROFILE_ITEM = Get-Item $PSCommandPath
if (($PROFILE_ITEM.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -and ($OHMYPOSH -eq "")) {
  # Resolve the symlink to the actual path and navigate to OMP config
  $target_directory = $PROFILE_ITEM.Target | Split-Path
  $OHMYPOSH = Join-Path $target_directory "..\ohmyposh\.config\ohmyposh\config.toml" | Resolve-Path
}

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# Set up zoxide
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
  Invoke-Expression (& { (zoxide init powershell --cmd cd | Out-String) })
}

# # Disable OMP for now
# # If $POSH_INIT is not set, then initialize oh-my-posh
# if ((Get-Command oh-my-posh -ErrorAction SilentlyContinue) -and (-not $POSH_INIT)) {
#   $POSH_INIT = $true
#   if (Test-Path $OHMYPOSH) {
#     oh-my-posh init pwsh --config $OHMYPOSH | Invoke-Expression
#   } else {
#     Write-Host "No oh-my-posh config file found. Using default config."
#     oh-my-posh init pwsh | Invoke-Expression
#   }
# }

function Prompt {
  "`n$PWD`nPS `$ "
}
