#
# Rust toolchain paths (enabled via rust/install)
#

: ${XDG_DATA_HOME:=$HOME/.local/share}

export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"

path_prefix "$CARGO_HOME"
