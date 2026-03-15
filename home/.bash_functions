function sr {
  if [ "$1" ]; then
    ssh root@"$1"
  else
    ssh -X -C -l root localhost
  fi
}

# Requires 'er' host range tool — uncomment if available
#function err {
#  if [ "$1" ]; then
#    X=$(er -e "$1" 2>&1)
#    if [ $? != 0 ]; then
#      echo "invalid range"
#    else
#      ssh -l root "$X"
#    fi
#  else
#    er -h
#  fi
#}

function netselect {
  command -v /usr/local/bin/netselect > /dev/null || { echo "netselect not found"; return 1; }
  if [ -f "$1" ]; then
    serverlist=$(cat "$1")
  else
    serverlist="$*"
  fi
  /usr/local/bin/netselect -vv -s 5 $serverlist
}

function make_me_cmd {
  echo 'useradd -m -s /bin/bash -G admin,sudo -c "Jeff Vier" jv'
}

function prepme {
  cd
  if [ ! -f "$HOME/.ssh/id_rsa.pub" ]; then
    echo "No SSH public key found at ~/.ssh/id_rsa.pub"
    cd -
    return 1
  fi
  KEY=$(cat "$HOME/.ssh/id_rsa.pub")
  ssh "$1" "[ ! -d .ssh ] && mkdir .ssh ; chmod 700 .ssh ; [ ! -f .ssh/authorized_keys ] && echo '$KEY' > .ssh/authorized_keys"
  cd -
}

# Requires 'er' host range tool — uncomment if available
#function cl {
#  er "clusters($1)"
#}
