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
   if [ "$userCheck" = "$user" ] 
   then
      echo "Bonjour John"
   else
      continue
   fi
done




#echo "$2@$3" #Nom de prompt a mettre 
#PS1="$user@$machine:~$" # set the prompt