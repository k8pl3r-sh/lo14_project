#!/bin/bash
echo  "####### USER #######"

# Variables
user=$1
machine=$2
i=$3

while true; do
  read -p "$user@$machine > " input
  case $input in
    "who")
      # Traitement pour la chaîne "who"
      echo "Vous avez entré la chaîne 'who'"
      ;;
    "rusers")
      # Traitement pour la chaîne "rusers"
      echo "Vous avez entré la chaîne 'rusers'"
      ;;
    "rhost")
      # Traitement pour la chaîne "rhost"
      echo "Vous avez entré la chaîne 'rhost'"
      ;;
    "rconnect")
      # Traitement pour la chaîne "rconnect"
      echo "Vous avez entré la chaîne 'rconnect'"
      ;;
    "su")
      # Traitement pour "su" X
      read -p 'New user: ' newUser
      ./rvsh.sh -connect $machine $newUser
      ;;
    "passwd")
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
            newPasswd=$(echo "$newPasswd1" | md5sum )
            jq --arg newPasswd "$newPasswd" '.['$i'].passwd |= $newPasswd' env/account.json > env/temp.json && mv env/temp.json env/account.json
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
      ;;
    "finger")
      # Traitement pour "finger" -> TODO : ajouter un listage de toute les users
      echo "Vous avez entré la chaîne 'finger'"
      ;;
    "write")
      # Traitement pour la chaîne "write"
      echo "Vous avez entré la chaîne 'write'"
      ;;
    "exit")
      # Traitement pour "exit"
      echo "Vous quittez $machine"
      break
      ;;
    *)
      # Default : on lance la chaine en bash
      eval $input
      ;;
  esac
done