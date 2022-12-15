#!/bin/bash
echo  "####### USER #######"
machine=$2
user=$3
json_file="/env/account.json"


userCheck=$(jq -r '"$3"' /mnt/d/Stockage/Dev/LO14/lo14_project/env/account.json) #récupération du user dans le json
echo "$userCheck"

pwd=$(pwd)

echo "  $pwd"

if [ "$user" == "$userCheck" ]; then #vérification du user
    echo "user found"
else
    echo "user not found"
fi

#machineCheck=$(jq -r $2 $json_file) #récupération de la machine dans le json

#echo "$2@$3" #Nom de prompt a mettre 
#PS1="$user@$machine:~$" # set the prompt