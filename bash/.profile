#
# ~/.profile
#

# I have decided to add global environment variables and PATH settings in
# .profile instead .bashrc as
#
# 1. It is global and sourced by non-bash shells and programs (like rofi)
# 2. It is sourced by login shells and not by every interactive subshell
#    so prevents re-declaring these variables every time a shell is invoked
#    interactively


#--------------------XDG Base Directory Specification-------------------

: ${XDG_CONFIG_HOME:=$HOME/.config}
: ${XDG_DATA_HOME:=$HOME/.local/share}
: ${XDG_CACHE_HOME:=$HOME/.cache}

export XDG_CONFIG_HOME
export XDG_DATA_HOME
export XDG_CACHE_HOME

#---------------------------------Editor--------------------------------

# default editor
export EDITOR=/usr/bin/vim
export VISUAL=/usr/bin/vim


#-------------------------------Themeing--------------------------------

export QT_QPA_PLATFORMTHEME="gtk2"
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export GTK_RC_FILES="$XDG_CONFIG_HOME/gtk-1.0/gtkrc"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"


#----------------------Misc Environment Variables-----------------------

# Program-specific environment variables and PATH entries live in
# $XDG_CONFIG_HOME/bash/profile.d/*.sh. Each install/setup script symlinks
# the snippets it needs, similar to /etc/profile.d or modprobe.d.


#---------------------Personal Environment Variables--------------------

# See profile.d/00-personal.sh (symlinked by bash/setup)


#----------------------------------PATH---------------------------------

# Prepend directories to PATH, skipping any that are already present or missing.
path_prefix() {
  _path_prefix_dir=
  for _path_prefix_dir in "$@"; do
    [ -d "$_path_prefix_dir" ] || continue
    case ":${PATH}:" in
      *:"${_path_prefix_dir}":*) ;;
      *) PATH="${_path_prefix_dir}:${PATH}" ;;
    esac
  done
  export PATH
  unset _path_prefix_dir
}

# Append directories to PATH, skipping any that are already present or missing.
path_postfix() {
  _path_postfix_dir=
  for _path_postfix_dir in "$@"; do
    [ -d "$_path_postfix_dir" ] || continue
    case ":${PATH}:" in
      *:"${_path_postfix_dir}":*) ;;
      *) PATH="${PATH}:${_path_postfix_dir}" ;;
    esac
  done
  export PATH
  unset _path_postfix_dir
}

#-------------------------------Profile.d-------------------------------

_profile_d="${XDG_CONFIG_HOME}/bash/profile.d"
if [ -d "$_profile_d" ]; then
  for _profile in "$_profile_d"/*.sh; do
    [ -f "$_profile" ] || continue
    . "$_profile"
  done
  unset _profile
fi
unset _profile_d


#-----------------------------------------------------------------------
