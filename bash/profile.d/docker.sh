#
# Docker configuration (enabled via docker setup/install)
#

: ${XDG_CONFIG_HOME:=$HOME/.config}

export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
