#!/bin/bash

# users functions that can be also used by the admin

who () {
      for ((w=0; w<=$(jq 'length' env/account.json); w++))
      do 
        for ((j=0; j<=$(jq '.['$w'].permissions | length' env/account.json); j++))
        do
          permQuoted=$(jq '.['$w'].permissions['$j']' env/account.json)
          permCheck="${permQuoted:1:-1}"
          if [ "$permCheck" = "$machine" ]; then 
            userQuoted=$(jq '.['$w'].name' env/account.json)
            userCheck="${userQuoted:1:-1}"
            lastConnectedQuoted=$(jq '.['$w'].lastConnected' env/account.json)
            lastConnectedCheck="${lastConnectedQuoted:1:-1}"
            echo "$userCheck $lastConnectedCheck"
          fi
        done
      done
}

rusers () {
      rusers=$(( $(jq 'length' env/account.json) - 1 ))
      for ((u=0; u<=$rusers; u++))
      do 
        if [ "$(jq '.['$u'].isConnected' env/account.json)" != "false" ]; then
          userQuoted=$(jq '.['$u'].name' env/account.json)
          userCheck="${userQuoted:1:-1}"
          isConnectedQuoted=$(jq '.['$u'].isConnected' env/account.json)
          isConnectedCheck="${isConnectedQuoted:1:-1}"
          lastConnectedQuoted=$(jq '.['$u'].lastConnected' env/account.json)
          lastConnectedCheck="${lastConnectedQuoted:1:-1}"
          echo "Connected : $userCheck on $isConnectedCheck since $lastConnectedCheck"
        fi
      done
}

rhost () {
      hostList=$(jq '.[] | .name' env/host.json)
      echo "List of hosts : $hostList"
}

rconnect () {
      read -p 'New host: ' newMachine
      ./rvsh.sh -connect $newMachine $user
      echo "This host doesn't exist"
      # TODO: noter les différentes machines sur le json pour gérer les connexions en chaines
}

su_ () {
  # Command su_ because su command exists in bash 
      if [ "$newUser" == "$user" ]; then
        echo "You are already connected as $newUser"
      elif [ "$newUser" == "admin" ]; then
        echo "You can't connect as admin"
      fi
      read -p 'New user: ' newUser
      ./rvsh.sh -connect $machine $newUser
}

passwd () {
      echo "Change password"
      read -sp 'Current password : ' passvar
      passQuoted=$(jq '.['$i'].passwd' env/account.json)
      passCheck="${passQuoted:1:-1}"  
      if [ "$(echo "$passvar" | md5sum )" == "$passCheck" ]; then
        echo ""
        echo "Correct password"
        read -sp 'New password: ' newPasswd1
        echo ""
        read -sp 'New password (again): ' newPasswd2
          if [ "$newPasswd1" == "$newPasswd2" ]; then
            jq --arg newPasswd "$(echo "$newPasswd1" | md5sum )" '.['$i'].passwd |= $newPasswd' env/account.json > env/temp.json && mv env/temp.json env/account.json
            echo ""
            echo "Password change successful"
          else
            echo "Passwords are not the same"
          fi
      else
        echo "Incorrect password, please retry"
      fi
}

finger () {
  read -p 'User: ' userInfo
  info=$(jq '.[] | select(.name == "'$userInfo'")' env/account.json)
  echo $info
}

write () {
  if [ $# -ge 2 ]; then
  usr=$1
    for ((w=0; w<=$(jq 'length' env/account.json); w++))
    do 
      userCheck=$(jq '.['$w'].name' env/account.json)
        if [ "${userCheck:1:-1}" == "$1" ]; then
          shift 1
          msg=$@
          jq --arg message "$msg" '.['$w'].message |= . + [$message]' env/account.json > env/temp.json && mv env/temp.json env/account.json
          echo "Le message "$msg" a bien été envoyé à $usr"
        fi
    done
  else 
    echo "Use the command 'write' with a message, like 'write user message' "
  fi
}

help_user () {
  # documentation of available functions if needed for the user
  echo "###################################### HELP ###########################################"
  echo "'who' command allows you to      : access to users connected on the host"
  echo "'rusers' command allows you to   : access to the list of users connected on the network"
  echo "'rhost' command allows you to    : return the list of hosts of the virtual network"
  echo "'rconnect' command allows you to : connect the user to another host"
  echo "'su' command allows you to       : change user on the same host"
  echo "'passwd' command allows you to   : change your own password on the network"
  echo "'finger' command allows you to   : give you informations on the user"
  echo "'write' command allows you to    : send a message to a connected user on the network"
  echo "'exit' command allows you to     : logout from a virtual host"
  echo "'help' command allows you to     : have documentation on functions"
  echo "###################################### HELP ###########################################"
}