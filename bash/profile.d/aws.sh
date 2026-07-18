#
# AWS CLI configuration paths (enabled via aws setup/install)
#

: ${XDG_CONFIG_HOME:=$HOME/.config}

export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME/aws/credentials"
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME/aws/config"
