# .bashrc

[ -n "$PS1" ] && export SAVEPS=${PS1}
[ -r /etc/bashrc ] && . /etc/bashrc
[ -r ~/.bash_functions ] && . ~/.bash_functions
[ -n "$SAVEPS" ] && export PS1=${SAVEPS}

export PATH=/usr/kerberos/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin:${HOME}/bin:${HOME}/scripts
# optional PATHs
[ -d "/opt/vagrant/bin" ] && export PATH=$PATH:/opt/vagrant/bin
[ ! -e "`which git`" ] && [ -e /usr/local/git/bin ] && export PATH=$PATH:/usr/local/git/bin
[ ! -e "/usr/games/nethack" ] && export PATH=$PATH:/usr/games

export LD_LIBRARY_PATH="/lib:/usr/lib:/usr/local/lib"

[ -f ~/.ssh/environment ] && export PROMPT_COMMAND='. ~/.ssh/environment'

## tell .bash_profile to not loop
#export bashrc_processed=1
[ $((${bash_profile_processed} + 1)) -ne 2 ] && [ -r ~/.bash_profile ] && . ~/.bash_profile

## no beeping:
[ -x "`which xset`" ] && xset -b

## Fuck you, capslock
[ -x "`which setxkbmap`" ] && setxkbmap -option ctrl:nocaps
