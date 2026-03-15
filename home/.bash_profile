# .bash_profile
#echo "this is bash_profile"

[ -r /etc/bash_completion ] && . /etc/bash_completion

#unset USERNAME
UNAME=$(uname)

export MANPATH="/usr/local/share/man:/usr/local/man:/usr/share/man:/usr/share/locale/en/man"
LHN=$(hostname)
SHN=${LHN%%.com}
SHN=${SHN%%.local}
SHN=${SHN%%.localdomain}

#export _POSIX2_VERSION=199209
export CDPATH=".:~:/usr/local"
export EDITOR="vi"
#export LANG="C"
export LANG="en_US.UTF-8"
export SHMUX_SSH_OPTS="-l root"

export HISTCONTROL=erasedups
export HISTSIZE=2000
export HISTFILESIZE=10000
export HISTTIMEFORMAT='%F %T '

# OSX stuff:
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

#alias curl='curl -C - -O'
alias psg='ps -ef |grep'
alias lst="ls -R | grep ':$' | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/ /' -e 's/-/|/'"
alias ulimit='ulimit -S'

alias sshenv='. ~/.ssh/environment'
alias sb='ssh -l boinger'
alias sj='ssh -l jv'
alias vsh="vagrant ssh"

alias msshr='mssh --sshopt -oStrictHostKeyChecking=no --sshopt -lroot'
alias mssh='mssh --sshopt -oStrictHostKeyChecking=no'

alias gd="git diff -M -b -u --color=always --src-prefix=YYYY## --dst-prefix=ZZZZ## | sed -e 's/+++ ZZZZ##/> /' -e '/--- YYYY##/d' -e 's/diff --git YYYY##.*/--------------------------------------------/'"
alias gs='git status'
alias gpr='git pull --rebase'
alias gspa='git subtree push-all'

command -v less > /dev/null && alias more='less'
command -v vim > /dev/null && alias vi='TERM=xterm-color;vim'

## ssh stuff
if [ -f "$HOME/.start_ssh-agent" ]; then
  if [ "$UNAME" = "Darwin" ]; then
    # macOS: use native keychain integration
    if [ -z "$(ssh-add -l | grep '.ssh')" ]; then
      echo "Adding SSH key via macOS keychain..."
      ssh-add --apple-use-keychain
    fi
  else
    # Linux: use keychain
    if ! command -v keychain > /dev/null; then
      echo "you need to install keychain"
    else
      SSH_ENV="$HOME/.ssh/environment"
      function start_keychain {
        echo -n "Initialising keychain..."
        keychain --eval -q > "${SSH_ENV}"
        echo succeeded
        chmod 600 "${SSH_ENV}"
      }

      if [ -f "${SSH_ENV}" ]; then
        . "${SSH_ENV}" > /dev/null
        ps -p ${SSH_AGENT_PID} -o comm= | grep ssh-agent$ > /dev/null || start_keychain
      else
        start_keychain
      fi

      # is somehow ssh-agent running without my key?
      if [ -z "$(ssh-add -l | grep '.ssh')" ]; then
        echo "Empty \`ssh-add -l\`.  Trying to fix, but might need help."
        ssh-add
      fi
    fi
  fi
fi
## end ssh stuff

# term colors
lightblack="\[\e[1;30m\]"
darkblack="\[\e[0;30m\]"
lightred="\[\e[1;31m\]"
darkred="\[\e[0;31m\]"
lightgreen="\[\e[1;32m\]"
darkgreen="\[\e[0;32m\]"
lightyellow="\[\e[1;33m\]"
darkyellow="\[\e[0;33m\]"
lightblue="\[\e[1;34m\]"
darkblue="\[\e[0;34m\]"
lightmagenta="\[\e[1;35m\]"
darkmagenta="\[\e[0;35m\]"
lightcyan="\[\e[1;36m\]"
darkcyan="\[\e[0;36m\]"
lightwhite="\[\e[1;37m\]"
darkwhite="\[\e[0;37m\]"
nocolor="\[\e[0m\]"
# end colors

case $UNAME in
  Linux)
    TSCOLOR=${lightblack}
    ;;
  *)
    TSCOLOR=${darkwhite}
    ;;
esac

#case $TERM in
# screen|xterm|xterm-color|xterm-256color|linux|console)
    PS1="\n${TSCOLOR}\t${nocolor}\n"
    [ "$USER" = "root" ] && PS1="${PS1}${lightred}"
    PS1="${PS1}\u${darkwhite}@${darkblue}${SHN}"
    if [ "$TERM" == "screen" ]; then
      PS1="${PS1} ${darkyellow}[SCREEN '${STY##*\.}']"
    fi
    PS1="${PS1}${nocolor}\n${darkwhite}[${darkgreen}\w${darkwhite}]${darkcyan}\$ ${nocolor}"
    export PS1
#   ;;
# *)
#   export PS1="\n\t\n\u@\h\n[\w]\$ "
#   HN=`hostname` && export PS1="\n\t\n\u@${HN%%.localdomain}\n[\w]\$ "
#   ;;
#esac

export bash_profile_processed=1
[ "${bashrc_processed:-0}" -ne 1 ] && [ -r ~/.bashrc ] && . ~/.bashrc

# MacPorts
[ -d /opt/local/bin ] && export PATH="/opt/local/bin:/opt/local/sbin:$PATH"

[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi
