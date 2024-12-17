# DistantJragon's Dotfiles

DJNCFG

---

This is a repository that holds all of my dotfiles! (Or at least the ones I want to sync/share). I hope to make these
files easy to understand, use, and modify for anyone. I use GNU Stow to manage my dotfiles on Linux, so these should
stay up to date as long as I continue to use each dotfile's respective program (and I remember to git push). As these
are my dotfiles, they might not be perfect for you, so I encourage you to look through them and tweak them to your
liking. If any dotfile's program happens to be cross-platform (Linux/Windows), I will make an effort to make the dotfile
cross-platform as well.

## Installation

### Prerequisites

- git
- GNU Stow (for Linux)
- PowerShell (for Windows)
- Knowledge found in the [wiki](https://www.github.com/DistantJragon/.dotfiles/wiki)

### Instructions

For Linux:

1. Clone this repository to your home directory.
2. `cd` into the repository.
3. Run `stow <package>` for each package in the repository that you want to install. For example, to install the
   `nvim` dotfiles, run `stow nvim`.

For Windows:

1. Clone this repository
2. Run the `install-windows.ps1` script in PowerShell. This script will create symbolic links in the necessary
   folders for the packages you wish to install.

## Editing and Staying Up to Date

You can update these dotfiles by simply running git pull in the repository's directory. However, should you wish to make
changes to any of the dotfiles due to personal preference and wish to make the update process less painful, you should
maintain a new git branch (or fork [more info to be added]) for your changes.  

(Any text inside angled brackets <> should be replaced with the appropriate text.)

1. Create a new branch with `git checkout -b <branch-name>` in the dotfiles' root directory.
2. Edit the dotfiles to your liking.
3. Add your changes with `git add <file>`. (Or `git add .` in the dotfiles' root directory to add all changes)
4. Commit your changes with `git commit -m "<commit-message>"`.
5. Once you want to update, switch back to the master branch with `git checkout master`.
6. Pull the latest changes with `git pull`. This will update the master branch to the latest version.
7. Switch back to your branch with `git checkout <branch-name>`.
8. Rebase your branch with the master branch with `git rebase master`. This will apply the latest changes to your
   branch.
9. Resolve any conflicts that may arise from the rebase. Then continue the rebase with `git rebase --continue`.
10. Repeat steps 3-9 as necessary.

Here is an overview of the commands used in the above steps:

    git checkout -b <branch-name>
    git add .
    git commit -m "<msg>"
    git checkout master
    git pull
    git checkout <branch-name>
    git rebase master
    git rebase --continue
