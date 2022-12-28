#!/bin/bash

# users functions that can be also used by the admin

who () {
  # Traitement pour "who" X
      echo "Vous avez entré la chaîne 'who'"
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
  # Traitement pour "rusers"
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
          echo "Connecté : $userCheck sur $isConnectedCheck depuis $lastConnectedCheck"
        fi
      done
}

rhost () {
  # Traitement pour "rhost" X
      hostList=$(jq '[ .[] | .permissions[] ] | unique' env/account.json)
      echo "Voici la liste des machines : $hostList"
}

rconnect () {
  # Traitement pour "rconnect" X
      read -p 'New machine: ' newMachine
      ./rvsh.sh -connect $newMachine $user
      # TODO: noter les différentes machines sur le json pour gérer les connexions en chaines
}

su_ () {
  # Command su_ because su command exists in bash
  # Traitement pour "su" X
      read -p 'New user: ' newUser
      ./rvsh.sh -connect $machine $newUser
}

passwd () {
  # Traitement pour "passwd" X
      echo "Changement de mot de passe"
      read -sp 'Mot de passe actuelle : ' passvar
      passQuoted=$(jq '.['$i'].passwd' env/account.json)
      passCheck="${passQuoted:1:-1}"  
      if [ "$(echo "$passvar" | md5sum )" == "$passCheck" ]; then
        echo ""
        echo "Mot de passe correct"
        read -sp 'New password: ' newPasswd1
        echo ""
        read -sp 'New password (again): ' newPasswd2
          if [ "$newPasswd1" == "$newPasswd2" ]; then
            jq --arg newPasswd "$(echo "$newPasswd1" | md5sum )" '.['$i'].passwd |= $newPasswd' env/account.json > env/temp.json && mv env/temp.json env/account.json
            echo ""
            echo "Mot de passe changé"
          else
            echo "Les deux mots de passe ne correspondent pas"
            continue
          fi
      else
        echo "Mot de passe incorrect, veuillez réessayer"
        continue
      fi
}

finger () {
  # Traitement pour "finger" X -> vrai utilité ?  
      read -p 'User: ' userInfo
      info=$(jq '.[] | select(.name == "'$userInfo'")' env/account.json)
      echo $info
}

write () {
  # Traitement pour "write" # $1=user, $2=machine, $3=message # Comment faire pour récupérer les variables à la suite de la commande ?
      if [ "$1" == "" ]; then # user
        echo "Vous ne pouvez pas utiliser cette commande"
        continue
      fi
}

exit_ () {
  # Traitement pour "exit"
      echo "Vous quittez $machine"
      jq '.['$i'].isConnected |= false' env/account.json > env/temp.json && mv env/temp.json env/account.json
      break # TODO: doesn't work: line 111: break: only meaningful in a `for', `while', or `until' loop
      # TODO: gérer la déconnexion si machines successives
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