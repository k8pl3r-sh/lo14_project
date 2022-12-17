#!/bin/bash
echo  "####### USER #######"

# Variables
machine=$2
user=$3
json_file="env/account.json"
iMax=$(jq 'length' $json_file);

# Check if user is in json file
for ((i=0; i<=$iMax; i++))
do
   userQuoted=$(jq '.['$i'].name' $json_file)
   userCheck="${userQuoted:1:-1}" # remove quotes

   permQuoted=$(jq '.['$i'].name' $json_file)
   permCheck="${userQuoted:1:-1}" # remove quotes

      #if [[ "$uservar"=="admin" && "$(echo "$passvar" | md5sum )"=="$passwd" ]]; then

   if [ "$userCheck" = "$user" ]; then # TODO : rajouter une condition qui vérifie la permission de l'utilisateur pour la machine donné 
      echo "Bonjour John" # TODO : 2e condition ou il doit rentrer le mot de passe + vérification du mot de passe en md5
   else
      continue
   fi
done




#echo "$2@$3" #Nom de prompt a mettre 
#PS1="$user@$machine:~$" # set the prompt