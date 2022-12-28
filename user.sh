#!/bin/bash
echo  "####### USER #######"

# Variables
user=$1
machine=$2
i=$3

# functions
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
}

# Comptage + lecture des messages
nbMessage=$(jq '.['$i'].message | length' env/account.json)
if [ $nbMessage -eq 0 ]; then
    echo "Vous n'avez pas de nouveau message" 
  elif [ $nbMessage -eq 1 ]; then
    echo "Vous avez un nouveau message"
      message=$(jq '.['$i'].message[0]' env/account.json)
      echo "Message : $message"    
  else
    echo "Vous avez $nbMessage nouveaux messages"
    ((nbMessage--))
    for ((m=0; m<=$nbMessage; m++))
    do
      message=$(jq '.['$i'].message['$m']' env/account.json)
      echo "Message $m : $message"
    done  
  fi

# Suppression des messages après lecture
jq '.['$i'].message |= []' env/account.json > env/temp.json && mv env/temp.json env/account.json

# Mise à jour de lastConnected
jq --arg connect "$(date +"%d-%m-%Y %H:%M:%S")" '.['$i'].lastConnected |= $connect' env/account.json > env/temp.json && mv env/temp.json env/account.json

# Passage en mode isConnected
jq --arg machine "$machine" '.['$i'].isConnected |= $machine' env/account.json > env/temp.json && mv env/temp.json env/account.json

while true; do
  read -p "$user@$machine > " input
  case $input in
    "who")
      who
      ;;
    "rusers")
      rusers
      ;;
    "rhost")
      rhost
      ;;
    "rconnect")
      rconnect
      ;;
    "su")
      su_
      ;;
    "passwd")
      passwd
      ;;
    "finger")
      finger
      ;;
    "write")
      write
      ;;
    "exit")
      exit_
      ;;
    *)
      # Default : on lance la chaine en bash
      eval $input
      ;;
  esac
done