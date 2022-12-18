#!/usr/bin/env bash

set_tmux_option() {
  local option="$1"
  local value="$2"
  tmux set-option -gq "$option" "$value"
}

get_tmux_option() {
  local option="$1"
  local default_value="$2"
  local option_value="$(tmux show-option -gqv "$option")"
  if [ -z "$option_value" ]; then
    echo "$default_value"
  else
    echo "$option_value"
  fi
}

# get files age in seconds
get_file_age() { # $1 - cache file
  local file_path="${1:-}"
  local now=$(date +%s)
  local file_modification_timestamp=$(stat -c "%Y" "$file_path" 2>/dev/null || echo 0)
  if [ $file_modification_timestamp -ne 0 ]; then
    echo $((now - file_modification_timestamp))
  else
    # return 0 if could not get cache modification time, eg. file does not exist
    echo 0
  fi
}

# found at https://stackoverflow.com/a/34938751
urlencode() {
  # urlencode <string>

  local length="${#1}"
  for (( i = 0; i < length; i++ )); do
    local c="${1:i:1}"
    case $c in
      [a-zA-Z0-9.~_-:/]) printf "$c" ;;
      *) printf '%%%x' \'"$c" ;;
    esac
  done
}
