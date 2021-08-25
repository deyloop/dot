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

export XDG_CONFIG_HOME
export XDG_DATA_HOME

#---------------------------------Editor--------------------------------

# making vim conform to XDG Base Directory Specification
export VIMINIT="set nocp | source ${XDG_CONFIG_HOME}/vim/vimrc"
export VIMXDG=1

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

PATH="$CARGO_HOME:$PATH"
PATH="$SCRIPTS_DIR:$PATH"
PATH="$HOME/.local/bin:$PATH"
export PATH


#-----------------------------------------------------------------------
