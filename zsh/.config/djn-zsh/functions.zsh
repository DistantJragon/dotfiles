#!/usr/bin/env zsh

DJN_MAX_SHORTENED_CWD_LENGTH=20

# This is run within the chpwd hook, so it runs after the directory is changed, but before the prompt is generated.
djn-shorten-cwd() {
  local cwd="$PWD"
  local home="$HOME"

  # Replace home directory with ~
  if [[ "$cwd" == "$home"* ]]; then
    cwd="~${cwd#$home}"
  fi

  # # While the path is too long, shorten it by taking off the first directory
  # local shortened="$cwd"
  # while ((${#shortened} > ${DJN_MAX_SHORTENED_LENGTH:-20})); do
  #   shortened="${shortened#*/}"
  # done

  # If the cwd is too long, get the last x characters, then remove the starting characters until the first slash
  local shortened="$cwd"

  if ((${#shortened} > DJN_MAX_SHORTENED_CWD_LENGTH)); then
    # We add 1 to max_length because we are removing at least one character (at least one slash) no matter what
    shortened="${shortened: -$((DJN_MAX_SHORTENED_CWD_LENGTH + 1))}"
    shortened="${shortened#*/}"
  fi

  DJN_SHORTENED_CWD="$shortened"
}

# This is run within the chpwd hook
djn-detect-git() {
  if ! DJN_GIT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null); then
    DJN_GIT_ROOT=""
  fi
}

# This is run within the precmd hook, so it runs before the prompt is generated.
djn-git-check-ahead-behind() {
  if [[ -z "$DJN_GIT_ROOT" ]]; then
    DJN_GIT_AHEAD=0
    DJN_GIT_BEHIND=0
    DJN_GIT_BRANCH=""
    return
  fi
  DJN_GIT_BRANCH=$(git branch --show-current 2>/dev/null)
  read DJN_GIT_AHEAD DJN_GIT_BEHIND < <(git rev-list --left-right --count HEAD...@{upstream} 2>/dev/null || echo "0 0")
}

djn-git-check-dirty() {
  if [[ -z "$DJN_GIT_ROOT" ]]; then
    DJN_GIT_DIRTY=0
    return
  fi

  if git diff --quiet; then
    DJN_GIT_DIRTY=0
  else
    DJN_GIT_DIRTY=1
  fi
}

djn-reset-last-exit-code() {
  return $1
}
