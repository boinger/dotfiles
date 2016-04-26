# .bash_profile
#echo "this is bash_profile"

[ -r /etc/bash_completion ] && . /etc/bash_completion

#unset USERNAME
UNAME=`uname`

export MANPATH="/usr/local/share/man:/usr/local/man:/usr/share/man:/usr/share/locale/en/man"
LHN=`hostname`
SHN=${LHN%%.com}
SHN=${SHN%%.local}
SHN=${SHN%%.localdomain}

alias gif2png='gif2png -O'
alias vncviewer='vncviewer -passwd $HOME/.vnc/passwd'

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

alias gd="git diff -b | sed -e 's/^+++ b\//> /' -e '/^--- a/d'"
alias gs='git status'
alias gpr='git pull --rebase'
alias gspa='git subtree push-all'

#alias push_dognabit='test -d /mnt/sshfs0/html/ || sshfs mmvier@dognabit.com:./ /mnt/sshfs0/ && rsync -CrlptoDv ~/Documents/Sites/dognabit/ /mnt/sshfs0/html/'

[ -e "`which less`" ] && alias more='less'
[ -e "`which vim`" ] && alias vi='TERM=xterm-color;vim'

## ssh stuff
if [ -f .start_ssh-agent ]; then
  if [ -z "`which keychain`" ]; then
    echo "you need to install keychain"
  else
    SSH_ENV="$HOME/.ssh/environment"
    function start_keychain {
      echo -n "Initialising keychain..."
      keychain --eval -q > ${SSH_ENV}
      echo succeeded
      chmod 600 ${SSH_ENV}
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
      ssh-add .ssh/*-FXCM
      ssh-add .ssh/*-MOZILLA
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
[ $((${bashrc_processed} + 1)) -ne 2 ] && [ -r ~/.bashrc ] && . ~/.bashrc
#[ -r ~/.bashrc ] && . ~/.bashrc

# MacPorts Installer addition on 2014-12-28_at_16:46:45: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"

[[ -d "$HOME/.rvm/bin" ]] && export PATH=$PATH:$HOME/.rvm/bin
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
#rvm use 2.2.4 --default
