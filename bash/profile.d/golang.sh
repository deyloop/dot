#
# Go toolchain paths (enabled via golang/install)
#

: ${XDG_DATA_HOME:=$HOME/.local/share}

export GO_PATH="$XDG_DATA_HOME/go"
export GOPATH="$HOME/.local/go/packages"

path_postfix "$HOME/.local/go/bin" "$GOPATH/bin"
