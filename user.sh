#!/bin/bash
echo  "####### USER #######"

# Variables
machine=$2
user=$3

while true; do
  # Demande à l'utilisateur de saisir une chaîne de caractères
  read -p "Entrez une chaîne de caractères : " input

  # Utilise un switch pour traiter les différentes chaînes de caractères possibles
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
      # Traitement pour la chaîne "passwd"
      echo "Vous avez entré la chaîne 'passwd'"
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
      # Exécute la chaîne de caractères entrée par l'utilisateur
      eval $input
      ;;
  esac
done