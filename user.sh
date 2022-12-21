#!/bin/bash
echo  "####### USER #######"

# Variables
machine=$2
user=$3

# Check if user is in json file
for ((i=0; i<=$(jq 'length' env/account.json); i++))
do
   userQuoted=$(jq '.['$i'].name' env/account.json)
   userCheck="${userQuoted:1:-1}"

   if [ "$userCheck" = "$user" ]; then 

      for ((j=0; j<=$(jq '.['$i'].permissions | length' env/account.json); j++))
      do
         permQuoted=$(jq '.['$i'].permissions['$j']' env/account.json)
         permCheck="${permQuoted:1:-1}"

         if [ "$permCheck" = "$machine" ]; then # TODO : 2e condition ou il doit rentrer le mot de passe + vérification du mot de passe en md5
            echo "Bonjour $user" 
            read -sp 'Password: ' passvar
            passQuoted=$(jq '.['$i'].passwd' env/account.json)
            passCheck="${passQuoted:1:-1}"
               if [ "$(echo "$passvar" | md5sum )" == "$passCheck" ]; then
                  echo "Mot de passe correct"
                  exit 0
               else
                  echo "Mot de passe incorrect"
                  exit 1
               fi
         fi    
      done
   else
      continue
   fi
done

#if [[ "$uservar"=="admin" && "$(echo "$passvar" | md5sum )"=="$passwd" ]]; then

#echo "$2@$3" #Nom de prompt a mettre 
#PS1="$user@$machine:~$" # set the prompt