function sr {
  if [ $1 ]; then
    ssh -2 root@$1
  else
    ssh -X -C -l root localhost
  fi
}

function netselect {
  if [ -f $1 ]; then
    serverlist=`cat $1`
  else
    serverlist="$*"
  fi
  /usr/local/bin/netselect -vv -s 5 $serverlist
}

function prepme {
    cd
    KEY=$(cat .ssh/id_rsa.pub)
    ssh $1 "[ ! -d .ssh ] && mkdir .ssh ; chmod 700 .ssh ; [ ! -f .ssh/authorized_keys ] && echo $KEY > .ssh/authorized_keys"
    scp .bash_functions .bash_logout .bash_profile .bashrc $1:
    cd -
}

# range required:
function cl {
    er "clusters($1)"
}
