# .bashrc
#echo "this is bashrc"

[ -n "$DESKTOP_SESSION" ] && unset bash_profile_processed

[ "`uname`" == "Darwin" ] && SAVEPS=$PS1
[ -r /etc/bashrc ] && . /etc/bashrc
[ -r ~/.bash_functions ] && . ~/.bash_functions
[ "`uname`" == "Darwin" ] && [ -n "$SAVEPS" ] && export PS1=${SAVEPS} && unset SAVEPS

export PATH=/usr/kerberos/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin:${HOME}/bin:${HOME}/scripts
# optional PATHs
[ -d "/opt/vagrant/bin" ] && export PATH=$PATH:/opt/vagrant/bin
[ ! -e "`which git`" ] && [ -e /usr/local/git/bin ] && export PATH=$PATH:/usr/local/git/bin
[ ! -e "/usr/games/nethack" ] && export PATH=$PATH:/usr/games

export LD_LIBRARY_PATH="/lib:/usr/lib:/usr/local/lib"

[ -f ~/.ssh/environment ] && export PROMPT_COMMAND='. ~/.ssh/environment'

## no beeping:
[ -x "`which xset`" ] && xset -b > /dev/null 2>&1

## Fuck you, capslock
[ -x "`which setxkbmap`" ] && setxkbmap -option ctrl:nocaps > /dev/null 2>&1

# tell .bash_profile to not loop
export bashrc_processed=1

[ $((${bash_profile_processed} + 1)) -ne 2 ] && [ -r ~/.bash_profile ] && . ~/.bash_profile
#. ~/.bash_profile
