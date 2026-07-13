#!/usr/bin/bash

# Link a bash/profile.d snippet into the active profile.d directory.
# Usage (from an install or setup script):
#   source /path/to/dot/bash/profile-link.sh
#   link_bash_profile rust

link_bash_profile() {
  local name="${1%.sh}"
  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  : "${XDG_CONFIG_HOME:=$HOME/.config}"

  local profile_d="$XDG_CONFIG_HOME/bash/profile.d"
  local source="$script_dir/profile.d/${name}.sh"
  local target="$profile_d/${name}.sh"

  if [[ ! -f "$source" ]]; then
    printf 'bash profile snippet not found: %s\n' "$source" >&2
    return 1
  fi

  mkdir -p "$profile_d"
  ln -sf "$source" "$target"
}

unlink_bash_profile() {
  local name="${1%.sh}"
  : "${XDG_CONFIG_HOME:=$HOME/.config}"

  local target="$XDG_CONFIG_HOME/bash/profile.d/${name}.sh"
  [[ -L "$target" || -f "$target" ]] && rm -f "$target"
}
