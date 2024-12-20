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

$nvim_path = "$env:LOCALAPPDATA\nvim"
$nvim_data_path = "$env:LOCALAPPDATA\nvim-data"

function backup-nvim-folders {
  # Backup the folder
  $date = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
  $backup_folder = "${nvim_path}_$date"
  $data_backup_folder = "${nvim_data_path}_$date"
  if ((Test-Path $nvim_path) -and (-not (test-symlink "$nvim_path"))) {
    Move-Item "$nvim_path" "$backup_folder"
    Write-Host "nvim folder backed up to $backup_folder"
  }
  if (Test-Path "$nvim_data_path") {
    Move-Item "$nvim_data_path" "$data_backup_folder"
    Write-Host "nvim-data folder backed up to $data_backup_folder"
  }
}

function remove-nvim-folders {
  # Remove the existing nvim folders if they exist
  if (Test-Path "$nvim_path") {
    if (test-symlink "$nvim_path") {
      (Get-Item "$nvim_path").Delete()
    } else {
      Remove-Item "$nvim_path" -Recurse
    }
  }
  if (Test-Path "$nvim_data_path") {
    Remove-Item "$nvim_data_path" -Recurse
  }
  # Check if the folders were removed
  if (Test-Path "$nvim_path") {
    return 1
  }
  if (Test-Path "$nvim_data_path") {
    return 1
  }
  return 0
}

function new-nvim-symlink {
  # Create a symlink at %LOCALAPPDATA%\nvim pointing to nvim\.config\nvim
  $nvim_config_path = "..\nvim\.config\nvim"
  $nvim_config_full_path = Join-Path $PSScriptRoot $nvim_config_path | Resolve-Path
  New-Item -ItemType SymbolicLink -Path $nvim_path -Value $nvim_config_full_path
}

function install-nvim-interactive {
  # First, check if C:\Users\%USERNAME%\AppData\Local\nvim exists
  $user_continue = "y"
  if (Test-Path "$nvim_path") {
    # If it exists, ask the user if they want to backup the folder and continue
    $user_backup = Read-Host "nvim folder already exists in AppData\Local. Do you want to backup the folder and continue? (y/n)"
    if ($user_backup -eq "y") {
      backup-nvim-folders
    } else {
      $user_continue = Read-Host "Do you want to continue without backing up the folder? THIS WILL DELETE THE FOLDERS (y/n)"
    }
  }
  if ($user_continue -eq "y") {
    $remove_result = remove-nvim-folders
    if ($remove_result -eq 1) {
      Write-Host "Failed to remove existing nvim/nvim-data folder(s)"
    } else {
      # Install the package
      new-nvim-symlink
      Write-Host "nvim package installed"
    }
  }
}

function install-nvim {
  param (
    [switch]$Interactive
  )
  if ($Interactive) {
    install-nvim-interactive
  } else {
    backup-nvim-folders
    $remove_result = remove-nvim-folders
    if ($remove_result -eq 1) {
      return 1
    }
    new-nvim-symlink
    return 0
  }
}

if (-not $packages) {
  $packages = @()
}

$packages += @{
  Name = "neovim"
  Install = { install-nvim-interactive }
}

