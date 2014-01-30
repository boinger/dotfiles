# .bashrc
#echo "this is bashrc"

[ -n "$DESKTOP_SESSION" ] && unset bash_profile_processed

UNAME=`uname`

[ "$UNAME" == "Darwin" ] && SAVEPS=$PS1
[ -r /etc/bashrc ] && . /etc/bashrc
[ -r ~/.bash_functions ] && . ~/.bash_functions
[ "$UNAME" == "Darwin" ] && [ -n "$SAVEPS" ] && export PS1=${SAVEPS} && unset SAVEPS

export PATH=/usr/kerberos/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin:${HOME}/bin:${HOME}/scripts
# optional PATHs
[ -d "/opt/vagrant/bin" ] && export PATH=$PATH:/opt/vagrant/bin
[ -d "/opt/ec2-api-tools/bin" ] && export PATH=$PATH:/opt/ec2-api-tools/bin && export EC2_HOME=/opt/ec2-api-tools
[ ! -e "`which git 2>&1 > /dev/null`" ] && [ -e /usr/local/git/bin ] && export PATH=$PATH:/usr/local/git/bin
[ ! -e "/usr/games/nethack" ] && export PATH=$PATH:/usr/games

export LD_LIBRARY_PATH="/lib:/usr/lib:/usr/local/lib"

if [ "$UNAME" == "Darwin" ]; then
  export JAVA_HOME=$(/usr/libexec/java_home)
else
  export JAVA_HOME="/usr/lib/jvm/java-1.7.0-openjdk-1.7.0.51.x86_64/jre"
fi

[ -f ~/.ssh/environment ] && export PROMPT_COMMAND='. ~/.ssh/environment'

## no beeping:
[ -x "`which xset 2>&1 > /dev/null`" ] && xset -b > /dev/null 2>&1

## Fuck you, capslock
[ -x "`which setxkbmap 2>&1 > /dev/null`" ] && setxkbmap -option ctrl:nocaps > /dev/null 2>&1

# tell .bash_profile to not loop
export bashrc_processed=1

[ $((${bash_profile_processed} + 1)) -ne 2 ] && [ -r ~/.bash_profile ] && . ~/.bash_profile
#. ~/.bash_profile
