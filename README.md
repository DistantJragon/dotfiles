# DistantJragon's Dotfiles

DJNCFG

---

This is a repository that holds all of my dotfiles! (Or at least the ones I want to sync/share).
I hope to make these files easy to understand, use, and modify for anyone.
I use GNU Stow to manage my dotfiles on Linux, so these should stay up to date as long as I continue to use each
dotfile's respective program (and I remember to git push).
As these are my dotfiles, they might not be perfect for you, so I encourage you to look through them and tweak them to
your liking.
If any dotfile's program happens to be cross-platform (Linux/Windows), I will make an effort to make the dotfile
cross-platform as well.

## Installation

### Prerequisites

- git
- GNU Stow (for Linux)
- PowerShell (for Windows)
- Knowledge found in the [wiki](https://www.github.com/DistantJragon/.dotfiles/wiki)

### Instructions

For Linux:

1. Clone this repository to your home directory
   (or anywhere you like if you're fine with an extra option in the stow command).
2. `cd` into the repository.
3. Run `stow <package>` for each package in the repository that you want to install.
   For example, to install the `nvim` dotfiles, run `stow nvim`.

   If the repository is not in your home directory,
   you will need to specify the path to the repository with the `-t` option.

For Windows:

1. Clone this repository
2. Run the `install/install.ps1` script in PowerShell.
   This script will create symbolic links in the necessary folders for the packages you wish to install.

## Editing and Staying Up to Date

You can update these dotfiles by simply running git pull in the repository's directory.
However, should you wish to make changes to any of the dotfiles due to personal preference and wish to make the update
process less painful, you should maintain a fork of this repository or at least a separate branch.
See [this wiki page](https://github.com/DistantJragon/.dotfiles/wiki/Syncing-and-Updating) for more information.
