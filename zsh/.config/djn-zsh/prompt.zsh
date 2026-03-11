#!/usr/bin/env zsh

# This is run within the precmd hook, so it runs before the prompt is generated.
djn-prompt-cmd() {
  local exit_code=$?
  local error_color
  (( exit_code )) && error_color="%1F" || error_color="%f"

  local left right filler fill_width

  local venv=""
  [[ -n "$VIRTUAL_ENV" ]] && venv=" "

  local git_branch="" git_dirty="" git_ahead="" git_behind=""
  [[ -n "$DJN_GIT_BRANCH" ]] && git_branch="  ${DJN_GIT_BRANCH}"
  (( DJN_GIT_DIRTY )) && git_dirty=" *"
  (( DJN_GIT_AHEAD )) && git_ahead="↑${DJN_GIT_AHEAD} "
  (( DJN_GIT_BEHIND )) && git_behind="↓${DJN_GIT_BEHIND} "

  left="%4F${DJN_SHORTENED_CWD}%5F${git_branch}%3F${git_dirty}"
  right="%5F${git_ahead}${git_behind}%3F${venv}%f%D{%H:%M:%S}"

  # Subtact from 80 the length of the left and right parts, and the two spaces.
  # Length of left is 9 bigger than reality due to color formatting
  # Length of right is 12 bigger than reality due to time abd color formatting
  # 80 - ( left - 9 ) - ( right - 12 ) - 2
  # = 99 - right - left
  fill_width=$(( 99 - ${#left} - ${#right} ))
  (( fill_width < 0 )) && fill_width=0

  filler=${(l:$fill_width::·:)}

  PS1="${left} %f"$'%{\e[2m%}'"${filler}"$'%{\e[22m%}'%f" ${right}
${error_color}❯%f "
}
