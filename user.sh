#!/bin/bash
echo  "####### USER #######"
machine=$2
user=$3
json_file="env/account.json"
userCheck=$(jq '"john"' $json_file)
iMax=$(jq 'length' $json_file);


for ((i=1; i<=$iMax; i++))
do
   userCheck=$(jq '[].name' $json_file)
   echo "yo"

   if [ "$userCheck" == "$user" ] 
   then
      echo "Bonjour Paul"
   else
      echo "Je ne connais pas ton nom"
   fi
done

#REGEX jq pour accèder à l'array : .[].name
 #récupération du user dans le json
echo "$userCheck"
echo "$user"

#echo "$2@$3" #Nom de prompt a mettre 
#PS1="$user@$machine:~$" # set the prompt