#!/bin/bash


########################## VARIABLES #############################

passwd='63a9f0ea7bb98050796b649e85481845' # root hashed in md5

passwordUser="d8e8fca2dc0f896fd7cb4cb0031ba249" # test hashed in md5


########################## MAIN #############################

# User connection
if [ "$1" == "-connect" ]; then
	machine=$2
	user=$3
	if [[ -z "$2" || -z "$3" ]]; then # Check that user and machine variables are not empty
		echo "Retry by providing <machine_name> and <username> please"
	fi

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
	echo "Bonjour admin" 
    read -sp 'Mot de passe : ' passvar
    passQuoted=$(jq '.[0].passwd' env/account.json)
    passCheck="${passQuoted:1:-1}"
    if [ "$(echo "$passvar" | md5sum )" == "$passCheck" ]; then # TODO: à réparer
        echo "Mot de passe correct"
        ./admin.sh 
    else
        echo "Mot de passe incorrect, veuillez réessayer"
    fi

# To delete: 
#	if [[ "$(echo "$passvar" | md5sum )"=="$passwd" ]]; then
#		# TODO: homogéiniser le if avec le if du test du user
#		./admin.sh
#	fi

else
	echo "Please retry and specify a command: '-admin' or '-connect'"

fi


