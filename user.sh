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
      # Traitement pour la chaîne "su"
      echo "Vous avez entré la chaîne 'su'"
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
        read -sp 'New password: ' newpasswd1
        echo ""
        read -sp 'New password (again): ' newpasswd2
          if [ "$newpasswd1" == "$newpasswd2" ]; then
            newpasswd=$(echo "$newpasswd1" | md5sum )
            jq --arg newpasswd "$newpasswd" '.['$i'].passwd |= $newpasswd' env/account.json > env/temp.json && mv env/temp.json env/account.json
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
      # Traitement pour la chaîne "finger"
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