# .bash_profile


[ -r /etc/bash_completion ] && . /etc/bash_completion

#unset USERNAME
UNAME=`uname`

##case $UNAME in
##    Linux)
        export MANPATH="/usr/local/apache2/man:/usr/local/share/man:/usr/local/man:/usr/local/rrdtool/man:/usr/local/mrtg/man:/usr/local/netflow/man:/usr/local/squid/man:/usr/X11R6/man:/usr/share/man:/usr/share/locale/en/man:/usr/bin/man:/var/qmail/man"
  LHN=`hostname`
  SHN=${LHN%%.com}
##        ;;
##esac

#export PATH=$PATH:/usr/games:/opt/kde/bin:/opt/gnome/bin
#export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/lib/qt3/lib/pkgconfig:/usr/lib/pkgconfig:/opt/gnome/lib/pkgconfig

alias gif2png='gif2png -O'
alias vncviewer='vncviewer -passwd $HOME/.vnc/passwd'

export _POSIX2_VERSION=199209
export CDPATH=".:~:/usr/local"
export EDITOR="vi"
export LANG="C"
export GREP_OPTIONS="--exclude=*.svn*"

export HISTCONTROL=erasedups
export HISTSIZE=2000
export HISTFILESIZE=10000
export HISTTIMEFORMAT='%F %T '

# OSX stuff:
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

alias curl='curl -C - -O'
alias psg='ps -ef |grep'
alias lst="ls -R | grep ':$' | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/ /' -e 's/-/|/'"
alias ulimit='ulimit -S'

alias sshenv='. ~/.ssh/environment'
alias sb='ssh -l boinger'
alias sj='ssh -l jv'

[ -e "`which less`" ] && alias more='less'
[ -e "`which vim`" ] && alias vi='TERM=xterm-color;vim'

## ssh stuff
if [ "${HOSTNAME%%.*}" == "jvdesktop" ]; then
    SSH_ENV="$HOME/.ssh/environment"
    function start_agent {
        echo -n "Initialising new SSH agent..."
        /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
        echo succeeded
        chmod 600 "${SSH_ENV}"
        . "${SSH_ENV}" > /dev/null
        /usr/bin/ssh-add
        trap "kill $SSH_AGENT_PID" 0
    }

    if [ -f "${SSH_ENV}" ]; then
        . "${SSH_ENV}" > /dev/null
        ps -p ${SSH_AGENT_PID} -o comm= | grep ssh-agent$ > /dev/null || start_agent
    else
        start_agent
    fi

    # is somehow ssh-agent running without my key?
    if [ -z "$(ssh-add -l | grep -o '.ssh')" ]; then
        /usr/bin/ssh-add
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

#case $TERM in
#    screen|xterm|xterm-color|xterm-256color|linux|console)
        PS1="\n${darkwhite}\t${nocolor}\n"
        [ "$USER" = "root" ] && PS1="${PS1}${lightred}"
        PS1="${PS1}\u${darkwhite}@${darkblue}${SHN}"
        if [ "$TERM" == "screen" ]; then
            PS1="${PS1} ${darkyellow}[SCREEN '${STY##*\.}']"
        fi
        PS1="${PS1}${nocolor}\n${darkwhite}[${darkgreen}\w${darkwhite}]${darkcyan}\$ ${nocolor}"
        export PS1
#        ;;
#    *)
#        export PS1="\n\t\n\u@\h\n[\w]\$ "
#        ;;
#esac

## tell .bashrc not to loop.
export bash_profile_processed=1
#[ $((${bashrc_processed} + 1)) -ne 2 ] && [ -r ~/.bashrc ] && . ~/.bashrc
[ -r ~/.bashrc ] && . ~/.bashrc
