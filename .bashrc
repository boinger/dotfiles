# .bashrc

[ -r /etc/bashrc ] && . /etc/bashrc
[ -r ~/.bash_functions ] && . ~/.bash_functions

export PATH=/usr/kerberos/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin:${HOME}/bin:${HOME}/scripts
[ ! -e "`which git`" ] && [ -e /usr/local/git/bin ] && export PATH=$PATH:/usr/local/git/bin
export LD_LIBRARY_PATH="/lib:/usr/lib:/usr/local/lib"

[ -f ~/.ssh/environment ] && export PROMPT_COMMAND='. ~/.ssh/environment'

## tell .bash_profile to not loop
export bashrc_processed=1
[ $((${bash_profile_processed} + 1)) -ne 2 ] && [ -r ~/.bash_profile ] && . ~/.bash_profile

## no beeping:
#[ ${HOSTNAME%%.*} == "whatever" ] && [ -x "`which xset`" ] && xset -b
