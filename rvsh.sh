#!/bin/bash


########################## MAIN #############################

passwd='63a9f0ea7bb98050796b649e85481845' # root hashed in md5

passwordUser="d8e8fca2dc0f896fd7cb4cb0031ba249" # test hashed in md5

# User connection
if [ "$1" == "-connect" ]; then
	machine=$2
	user=$3
	for ((i=0; i<=$(jq 'length' env/account.json); i++))
	do
   		userQuoted=$(jq '.['$i'].name' env/account.json)
   		userCheck="${userQuoted:1:-1}"
   		if [ "$userCheck" = "$user" ]; then 
      		for ((j=0; j<=$(jq '.['$i'].permissions | length' env/account.json); j++))
      		do
         		permQuoted=$(jq '.['$i'].permissions['$j']' env/account.json)
         		permCheck="${permQuoted:1:-1}"
         		if [ "$permCheck" = "$machine" ]; then 
            		echo "Bonjour $user" 
            		read -sp 'Mot de passe : ' passvar
            		passQuoted=$(jq '.['$i'].passwd' env/account.json)
            		passCheck="${passQuoted:1:-1}"	
               			if [ "$(echo "$passvar" | md5sum )" == "$passCheck" ]; then
                  			echo "Mot de passe correct"
                  			./user.sh $user $machine $i
               			else
                  			echo "Mot de passe incorrect, veuillez réessayer"
							continue
               			fi
         		fi    
      		done
   		fi
	done

# Admin connection
elif [ "$1" == "-admin" ]; then
	echo "####### ADMINISTRATION #######"
	read -p 'Username: ' uservar
	read -sp 'Password: ' passvar

	if [[ "$uservar"=="admin" && "$(echo "$passvar" | md5sum )"=="$passwd" ]]; then
		./admin.sh
	fi
fi
