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

export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME/aws/credentials"
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME/aws/config"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export GO_PATH="$XDG_DATA_HOME/go"
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"


#---------------------Personal Environment Variables--------------------

export SCRIPTS_DIR="$HOME/.local/bin/scripts"
export GITHUB_USER="$USER"
export REPOS_DIR="$HOME/repos"

#----------------------------------PATH---------------------------------

# Prepend directories to PATH, skipping any that are already present.
path_prefix() {
  _path_prefix_dir=
  for _path_prefix_dir in "$@"; do
    case ":${PATH}:" in
      *:"${_path_prefix_dir}":*) ;;
      *) PATH="${_path_prefix_dir}:${PATH}" ;;
    esac
  done
  export PATH
  unset _path_prefix_dir
}

# Append directories to PATH, skipping any that are already present.
path_postfix() {
  _path_postfix_dir=
  for _path_postfix_dir in "$@"; do
    case ":${PATH}:" in
      *:"${_path_postfix_dir}":*) ;;
      *) PATH="${PATH}:${_path_postfix_dir}" ;;
    esac
  done
  export PATH
  unset _path_postfix_dir
}

path_prefix "$CARGO_HOME" "$SCRIPTS_DIR" "$HOME/.local/bin"

export GOPATH="$HOME/.local/go/packages"
path_postfix "$HOME/.local/go/bin" "$GOPATH/bin"


#-----------------------------------------------------------------------
