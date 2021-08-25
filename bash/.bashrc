#
# ~/.bashrc
#

# This bashrc is supposed to run only when the shell is invoked as an 
# interactove shell
[[ $- != *i* ]] && return


#------------------------------TERM Colors------------------------------

USE_COLOR=true

# Set colorful PS1 only on colorful terminals.  dircolors
# --print-database uses its own built-in database instead of using
# /etc/DIR_COLORS.  Try to use the external file first to take advantage
# of user additions.  Use internal bash globbing instead of external
# grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.config/dir_colors   ]] && match_lhs="${match_lhs}$(<~/.config/dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && USE_COLOR=true

if ${USE_COLOR} ; then
  # Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
  if type -P dircolors >/dev/null ; then
    if [[ -f ~/.config/dir_colors ]] ; then
      eval $(dircolors -b ~/.config/dir_colors)
    elif [[ -f /etc/DIR_COLORS ]] ; then
      eval $(dircolors -b /etc/DIR_COLORS)
    fi
  fi

  alias ls='ls --color=auto --group-directories-first'
  alias grep='grep --colour=auto'
  alias egrep='egrep --colour=auto'
  alias fgrep='fgrep --colour=auto'
fi

# This environment variable can be used to conditionally display colors
# in other scripts
export USE_COLOR


#------------------------------Shell Promt------------------------------

# Sets the PS1 prompt, loud and proper. Has git integrations and
# previous command status
__ps1() {
  local exit_code="$?"
  local branch=$(git branch --show-current 2>/dev/null)

  if ${USE_COLOR}; then
    local q='\[\e[0;35m\]'
    local g='\[\e[0;32m\]'
    local h='\[\e[0;34m\]'
    local w='\[\e[1;33m\]'
    local b='\[\e[1;31m\]'
    local u='\[\e[0;33m\]'
    local x='\[\e[0m\]'
    local s='\[\e[1;31m\]'
    local y='\[\e[1;38;2;255;255;0m\]'

    local user="$u\u"
    local host="$h\h"
    local dir="$w\W"
    [[ ${EUID} == 0 ]] && user="${u}root"
    [[ -n "$branch" ]] && branch="$g($b$branch$g)"
    [[ $exit_code != 0 ]] && exit_code="${y}⚠️  ${s}$exit_code" || exit_code=""

    PS1="$q[$user$g@$host$g:$dir$branch$q] $exit_code\n$q\$$x "
  else
    local user="\u"
    local host="\h"
    local dir="\W"
    [[ ${EUID} == 0 ]] && user="root"
    [[ -n "$branch" ]] && branch="(⎇ $branch)"

    PS1="[$user@$host:$dir$branch]\n\$"
  fi
}  
PROMPT_COMMAND="__ps1"


#-----------------------------------------------------------------------

unset safe_term match_lhs sh

#----------------------------Bash Completion----------------------------

# Completion for core utils, I guess
if [[ -r /usr/share/bash-completion/bash_completion ]]; then 
  source /usr/share/bash-completion/bash_completion
fi

complete -cf sudo


#-----------------------------Shell Options-----------------------------

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

shopt -s expand_aliases


# vi keybindings for terminal
set -o vi


#--------------------------------History--------------------------------

# Enable history appending instead of overwriting.  #139609
shopt -s histappend

# Ignores the current command if its duplicate of the previous command,
# Keeping the history clean and making it easier to press k or up to get
# to previous commands
HISTCONTROL=ingnoredups

# Huge history, cos my life depends on it
HISTSIZE=1000000


#---------------------------------CDPATH--------------------------------

: ${REPOS_DIR:="$HOME/repos"}
: ${GITHUB_USER:="$USER"}

CDPATH="."
CDPATH+=":~/.local/bin"
CDPATH+=":$REPOS_DIR"
CDPATH+=":$REPOS_DIR/github.com/$GITHUB_USER"
CDPATH+=":~"


#--------------------------------Aliases--------------------------------

alias cp="cp -i"                  # confirm before overwriting something
alias df='df -h'                  # human-readable sizes
alias free='free -m'              # show sizes in MB
alias more=less

alias '?'=duck

source cdl.sh # this is also sort of like an alias


#-----------------------------------------------------------------------

export MANPAGER="sh -c 'col -bx | bat -l man -p'"
