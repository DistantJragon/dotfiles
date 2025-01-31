#Requires -RunAsAdministrator

function test-symlink {
  param (
    [Parameter(Mandatory=$true)]
    [string]$Path
  )
  if (-not (Test-Path $Path)) {
    return $false
  }
  $symlink = Get-Item $Path
  return [bool]($symlink.Attributes -band [System.IO.FileAttributes]::ReparsePoint)
}

function backup-powershell-profile {
  # Backup the folder
  $date = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
  $backup = "${profile}_$date"
  if ((Test-Path $profile) -and (-not (test-symlink "$profile"))) {
    Move-Item "$profile" "$backup"
    Write-Host "powershell profile backed up to $backup"
  }
}

function remove-powershell-profile {
  # Remove the existing nvim folders if they exist
  if (Test-Path "$profile") {
    if (test-symlink "$profile") {
      (Get-Item "$profile").Delete()
    } else {
      Remove-Item "$profile"
    }
  }
   # Check if the profile was removed
  if (Test-Path "$profile") {
    return 1
  }
  return 0
}

function new-powershell-profile-symlink {
  $package_path = "..\..\powershell\Microsoft.PowerShell_profile.ps1"
  $package_full_path = Join-Path $PSScriptRoot $package_path | Resolve-Path
  New-Item -ItemType SymbolicLink -Path $profile -Value $package_full_path > $null
}

function install-powershell-profile-interactive {
  # First, check if a profile exists
  $user_continue = "y"
  if (Test-Path "$profile") {
    # If it exists, ask the user if they want to backup the folder and continue
    $user_backup = Read-Host "A powershell profile already exists. Do you want to backup the profile and continue? (y/n)"
    if ($user_backup -eq "y") {
      backup-powershell-profile
    } else {
      $user_continue = Read-Host "Do you want to continue without backing up the profile? THIS WILL OVERWRITE THE PROFILE (y/n)"
    }
  }
  if ($user_continue -eq "y") {
    $remove_result = remove-powershell-profile
    if ($remove_result -eq 1) {
      Write-Host "Failed to remove existing profile"
      return 1
    } else {
      new-powershell-profile-symlink
      Write-Host "powershell profile symlink created"
      return 0
    }
  }
  return 1
}

# function install-nvim {
#   param (
#     [switch]$Interactive
#   )
#   if ($Interactive) {
#     install-nvim-interactive
#   } else {
#     backup-nvim-folders
#     $remove_result = remove-nvim-folders
#     if ($remove_result -eq 1) {
#       return 1
#     }
#     new-nvim-symlink
#     return 0
#   }
# }

if (-not $packages) {
  $packages = @()
}

$packages += @{
  Name = "powershell-profile"
  Install = {
    install-powershell-profile-interactive
  }
}

