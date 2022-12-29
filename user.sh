#!/bin/bash
echo  "####### USER #######"

source functions.sh
# Variables
user=$1
machine=$2
i=$3



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
      echo "Vous quittez $machine"
      jq '.['$i'].isConnected |= false' env/account.json > env/temp.json && mv env/temp.json env/account.json
      break
      ;;
    "help")
      help_user
      ;;
    *)
      # Default : on lance la chaine en bash
      eval $input
      ;;
  esac
done