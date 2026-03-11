#!/usr/bin/env zsh

# This is run within the precmd hook, so it runs before the prompt is generated.
djn-prompt-cmd() {
  local exit_code=$? error_color
  (( exit_code )) && error_color="%1F" || error_color="%f"

  local left right filler fill_width

  local venv=""
  [[ -n "$VIRTUAL_ENV" ]] && venv=" "

  local git_head_display="" git_dirty="" git_ahead="" git_behind=""
  if [[ -n "$DJN_GIT_ROOT" ]]; then
    if [[ -n "$DJN_GIT_BRANCH" ]]; then git_head_display="  $DJN_GIT_BRANCH"
    elif [[ -n "$DJN_GIT_TAG" ]]; then git_head_display=" #$DJN_GIT_TAG"
    else git_head_display=" @$DJN_GIT_COMMIT"
    fi
    (( DJN_GIT_DIRTY )) && git_dirty=" *"
    if (( DJN_GIT_AHEAD )); then
      git_ahead="↑${DJN_GIT_AHEAD} "
      (( DJN_GIT_AHEAD > 99 )) && git_ahead="↑󰶼 "
    fi
    if (( DJN_GIT_BEHIND )); then
      git_behind="↓${DJN_GIT_BEHIND} "
      (( DJN_GIT_BEHIND > 99 )) && git_behind="↓󰶼 "
    fi
  fi

  left="%4F%${DJN_MAX_SHORTENED_CWD_LENGTH}>>${DJN_SHORTENED_CWD}%>>\
%5F%$DJN_MAX_GIT_HEAD_DISPLAY_LENGTH>>${git_head_display}%>>%3F${git_dirty}"
  right="%5F${git_ahead}${git_behind}%3F${venv}%f%D{%H:%M:%S}"

  local short_cwd_length git_head_display_length
  short_cwd_length=${#DJN_SHORTENED_CWD}
  git_head_display_length=${#git_head_display}
  short_cwd_length=$((
      short_cwd_length > DJN_MAX_SHORTENED_CWD_LENGTH
      ? DJN_MAX_SHORTENED_CWD_LENGTH
      : short_cwd_length
  ))
  git_head_display_length=$((
      git_head_display_length > DJN_MAX_GIT_HEAD_DISPLAY_LENGTH
      ? DJN_MAX_GIT_HEAD_DISPLAY_LENGTH
      : git_head_display_length
  ))
  fill_width=$((
      80 - short_cwd_length - git_head_display_length
      - ${#git_dirty} - ${#git_ahead} - ${#git_behind} - ${#venv} - 8 - 2
  ))
  (( fill_width < 0 )) && fill_width=0

  filler=${(l:$fill_width::·:)}

  PS1="${left}%f "$'%{\e[2m%}'"${filler}"$'%{\e[22m%}'"%f ${right}
${error_color}❯%f "
}
