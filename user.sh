#!/bin/bash
echo  "####### USER #######"

# Variables
machine=$1
user=$2
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
      # Traitement pour "su" 
      read -p 'New user: ' newUser
      ./rvsh.sh -connect $machine $newUser # TODO : ajouter un check pour voir si l'utilisateur existe, pas de réaction pour le moment
      ;;
    "passwd")
      # Traitement pour "passwd"
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
      # Traitement pour la chaîne "exit"
      echo "Vous avez entré la chaîne 'exit'"
      break
      ;;
    *)
      # Exécute la chaîne de caractères entrée par l'utilisateur par la machine basse
      eval $input
      ;;
  esac
done