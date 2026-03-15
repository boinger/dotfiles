# .bashrc
#echo "this is bashrc"

[ -n "$DESKTOP_SESSION" ] && unset bash_profile_processed

UNAME=$(uname)

[ "$UNAME" == "Darwin" ] && SAVEPS=$PS1
[ -r /etc/bashrc ] && . /etc/bashrc
[ -r ~/.bash_functions ] && . ~/.bash_functions
[ "$UNAME" == "Darwin" ] && [ -n "$SAVEPS" ] && export PS1=${SAVEPS} && unset SAVEPS

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/sbin:/usr/bin:/bin:${PATH}
[ -d "${HOME}/bin" ] && export PATH=${HOME}/bin:${PATH}
[ -d "${HOME}/scripts" ] && export PATH=${HOME}/scripts:${PATH}
[ -d "${HOME}/.local/bin" ] && export PATH=${HOME}/.local/bin:${PATH}
# optional PATHs
[ -d "/opt/vagrant/bin" ] && export PATH=$PATH:/opt/vagrant/bin
[ -d "/opt/ec2-api-tools/bin" ] && export PATH=$PATH:/opt/ec2-api-tools/bin && export EC2_HOME=/opt/ec2-api-tools
! command -v git > /dev/null 2>&1 && [ -d /usr/local/git/bin ] && export PATH=$PATH:/usr/local/git/bin
[ -d /usr/games ] && export PATH=$PATH:/usr/games

export LD_LIBRARY_PATH="/lib:/usr/lib:/usr/local/lib"

if [ "$UNAME" == "Darwin" ]; then
  export JAVA_HOME=$(/usr/libexec/java_home)
else
  if command -v java > /dev/null 2>&1; then
    export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))
  fi
fi

[ -f ~/.ssh/environment ] && export PROMPT_COMMAND='. ~/.ssh/environment'

## ImageMagick crap:
#export DYLD_LIBRARY_PATH="$DYLD_LIBRARY_PATH:/usr/lib:/opt/local/lib"

## no beeping:
[ -n "$DISPLAY" ] && command -v xset > /dev/null && xset -b > /dev/null 2>&1

## Fuck you, capslock
[ -n "$DISPLAY" ] && command -v setxkbmap > /dev/null && setxkbmap -option ctrl:nocaps > /dev/null 2>&1

# RVM (uncomment if needed)
#[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
#[[ -d "$HOME/.rvm/bin" ]] && export PATH="$PATH:$HOME/.rvm/bin"

# tell .bash_profile to not loop
export bashrc_processed=1

[ "${bash_profile_processed:-0}" -ne 1 ] && [ -r ~/.bash_profile ] && . ~/.bash_profile

if [ "$UNAME" == "Darwin" ]; then
  export PERL_MB_OPT="--install_base \"$HOME/perl5\""
  export PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"
  PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
fi


if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

export PYTHONPATH=${PYTHONPATH}:.
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

## Beak Keeper specific stuff
alias bkfa='cd ~/Projects/BeakKeeper/ChickIndex && echo "flutter analyze for Main App" && flutter analyze && cd ../chickindex_pet_sitter && echo "flutter analyze for Sitter App" && flutter analyze && cd ../chickindex_shared && echo "flutter analyze for shared resources" && flutter analyze && cd ../'
alias bkgs='cd ~/Projects/BeakKeeper/ChickIndex && echo "Main app" && git status && cd ../chickindex_pet_sitter && echo "Sitter app" && git status && cd ../chickindex_shared && echo "shared repo" && git status && cd ..'
alias bkp='cd ~/Projects/BeakKeeper/ChickIndex && echo "pushing Main app" && git push && cd ../chickindex_pet_sitter && echo "pushing Sitter app" && git push && cd ../chickindex_shared && echo "pushing shared repo" && git push && cd ..'
alias bkt='cd ~/Projects/BeakKeeper/ChickIndex && echo "flutter test for Main App" && flutter test && cd ../chickindex_pet_sitter && echo "flutter test for Sitter App" && flutter test && cd ../chickindex_shared && echo "flutter test for shared resources" && flutter test && cd ..'

# Secrets loaded from separate file (not committed to dotfiles)
[ -r ~/.secrets ] && . ~/.secrets
