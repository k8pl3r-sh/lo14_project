#!/bin/bash
echo  "####### USER #######"
machine=$2
user=$3
json_file="/env/account.json"

#REGEX jq pour accèder à l'array : .[].name
userCheck=$(jq '"john"' env/account.json) #récupération du user dans le json
echo "$userCheck"
echo "$user"

if [ "$user" == "$userCheck" ]; then #vérification du user
    echo "user $user found"
else
    echo "user not found"
fi

#machineCheck=$(jq -r $2 $json_file) #récupération de la machine dans le json

#echo "$2@$3" #Nom de prompt a mettre 
#PS1="$user@$machine:~$" # set the prompt